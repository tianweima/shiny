#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(wordcloud2)
library(dplyr)
dc <- read.csv("DC.csv")
dcna<- na.omit(dc)
marvel <- read.csv("MARVEL.csv")
marvelna<-na.omit(marvel)
DC<- data.frame(name=dcna$name,apperances=dcna$APPEARANCES)
MARVEL <- data.frame(name=marvelna$name,apperances=marvelna$APPEARANCES)
dcfemale <- dcna %>% filter(SEX =="Female Characters") %>% group_by(YEAR) %>% summarise(n=n())
dcmale <- dcna %>% filter(SEX =="Male Characters") %>% group_by(YEAR) %>% summarise(n=n())
marvelfemale <- marvelna %>% filter(SEX =="Female Characters") %>% group_by(Year) %>% summarise(n=n())
marvelmale <- marvelna %>% filter(SEX =="Male Characters") %>% group_by(Year) %>% summarise(n=n())
dcLGBT <- dcna %>% filter(GSM =="Homosexual Characters" | GSM =="Bisexual Characters") %>% group_by(YEAR) %>% summarise(n=n())
marvelLGBT <- marvelna %>% filter(GSM =="Homosexual Characters" | GSM =="Bisexual Characters") %>% group_by(Year) %>% summarise(n=n())

shinyServer(function(input, output) {
    # Create text output for Description tab
    output$text <- renderText({
        
        "To say the comic book industry has a slight gender skew is like saying Superman is kind of strong. Comic books — much like the film industry they now fuel — vastly under-represent women. The people who write comic books, particularly for major publishers, are overwhelmingly men. The artists who draw them are, too. The characters within them are also disproportionately men, as are the new characters introduced each year.
        The big two comic publishers, DC Comics and Marvel,have taken note of this disparity and are trying to diversify their offerings."
        
    })
    
    
    output$word <- renderWordcloud2({
        
        if(input$selection == 'DC'){
            wordcloud2(data=DC, size=0.2, fontFamily = 'Pacifico',color = 'random-light',
                       gridSize=15,  shuffle=F,shape = 'star',backgroundColor='black')
            #wordcloud2(data=DC, size = 1,shape = 'star')

        }
        
        else if(input$selection == 'MARVEL'){
            wordcloud2(data= MARVEL,size=0.2, fontFamily = 'Pacifico', color = 'random-dark',
                       gridSize=15,  shuffle=F, shape = 'star',backgroundColor='pink')
            
        }
    })
    
   
   output$plot1 <- renderPlot({
       if(input$DORM == "Character Added"){
           ggplot(data = dcna,aes(x=YEAR)) + geom_bar(color='blue') + ylab("number of character added") + ggtitle("DC") 
       }
       else if(input$DORM == "Character of Gender Added"){
           ggplot()+ geom_line(dcfemale,mapping=aes(x=YEAR,y=n),color="blue") + geom_line(marvelfemale,mapping=aes(x=Year,y=n),color="red")+ ylab("Female characters added")+ ggtitle("Female characters added(dc:blue,marvel:red)")
           
       }
       else if(input$DORM == "Character of LGBT Added"){
           ggplot(dcLGBT,aes(x=YEAR,y=n))+geom_bar(stat ='identity',color="blue")+ylab("DC.LGBT characters added") + ggtitle("DC.LGBT characters added")
           
       }
   })
    
   output$plot2 <-renderPlot({
       if(input$DORM == "Character Added"){
           ggplot(data = marvelna,aes(x=Year))+geom_bar(color='red')+ylab("number of character added")+ggtitle("MARVEL")
       }
       else if(input$DORM == "Character of Gender Added"){
           ggplot()+ geom_line(dcmale,mapping=aes(x=YEAR,y=n),color="blue") + geom_line(marvelmale,mapping=aes(x=Year,y=n),color="red")+ylab("Male characters added")+ggtitle("Male characters added(dc:blue,marvel:red)")
           
       }
       else if(input$DORM == "Character of LGBT Added"){
           ggplot(marvelLGBT,aes(x=Year,y=n))+geom_bar(stat ='identity',color="red")+ylab("MRAVEL.LGBT characters added") + ggtitle("MARVEL.LGBT characters added")
           
       }
   }) 
   
   output$table1<- renderTable({
       
     
       tbl_df(dcna)
       
       })
   
   output$table2<- renderTable({

       tbl_df(marvelna)

       })

})
