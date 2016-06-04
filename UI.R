library(shiny)
shinyUI(pageWithSidebar(
  headerPanel("Text Prediction"),
  sidebarPanel(
    h4('Prediction controls'),
    uiOutput('algoChoice'),
    uiOutput('algoOptions')    
    #p('Generates 2D normal data and scatterplots it with an ellipse bounding an expected quantile of plot points'),
    #p('Edit controls to control ellipse parameters and random data generation'),
    #numericInput('nsamples', 'Number of samples', 1000, min = 100, max = 10000, step = 100),
    #sliderInput('a', 'Major axis',value = 2, min = 0.1, max = 3, step = 0.05,),
    #sliderInput('b', 'Minor axis',value = 1, min = 0.1, max = 3, step = 0.05,),
    #sliderInput('theta', 'Angle (Radians)',value = 3.14/8, min = 0, max = 3.14, step = 3.14/100,),
    #sliderInput('aq', 'Area quantile',value = 0.90, min = 0, max = 0.999, step = 0.001,),
    #numericInput('seed', 'Random Seed', 1234, min = 100, max = 10000, step = 1),
    #p('Also includes fit line for ys~xs for generated data. Observe that the fit line is a much closer match for the angle theta when minor axis is small.')
  ),
  mainPanel(
    tabsetPanel(
      tabPanel("Prediction", verticalLayout(
        textInput('textInput', "Text Input"),
        textOutput("textOutput"))
      ),
      tabPanel("Instructions", HTML('
<p>Type text in to the text input box on the "Prediction" tab.
Try varying the prediction algorithm using the sidebar controls.</p>
<p>Sidebar options options include the following:</p>
<h3>n-Gram</h3>
<p>This set of algorithms uses a collection of previously
observed n-Grams (2, 3 or 4) in order to predict the next word.</p>
<ul>
  <li>all - This uses the Katz backoff algorithm and the full set of {2,3,4}-grams.</li>
  <li>bigram - Using the most prevalent bigram that starts with the last word of the presented text.</li>
  <li>trigram - Using the most prevalent trigram that starts with the last 2 words of the presented text.</li>
  <li>quadgram - Using the most prevalent quadgram that starts with the last 3 words of the presented text.</li>
</ul>
<h3>Java</h3>
<p>This algorithm used rJava to invoke Java prediction code. The original intention was
to implement the following algorithm.</p>
<p>Using the cleaned corpus, select all the words that appear more than once
and are not profane; this is the set of targets for a classification problem. We initially
try to train a classifier using a set of one-vs-many logistic classifiers. This is a large
set of logistic regressions, but it is easily distributed (training each target for the
binary 0/1 outcome using the corpus).</p>
<p>We choose as the set of training inputs a binary vector consisting of the following</p>
<ul>
  <li>A constant bias input (always 1)</li>
  <li>All the words in the input text (ignoring position)</li>
  <li>An input representing the leading word from each 2-gram in the corpus</li>
  <li>An input representing the leading 2-gram from each 3-gram in the corpus</li>
  <li>An input representing the leading 3-gram from each 4-gram in the corpus</li>
</ul>
<p>The idea is that the input vector captures both the immediate context with explicit
position, and all other context without regard for position. The key point is that the
logistic regression is done with an L1 penalty term for any non-zero coefficients.
This penalty will ensure sparsity of the resulting model representation, and by tuning
the penalty factor you can control the tradeoff between model accuracy and model size.</p>
<p>A low penalty factor would lead to a large number of non-zero coefficients, so the
resulting model would be large to store and slow to evaluate. Not appropriate for a
mobile text predictor, but maybe useful for some larger offline text analysis program.</p>
<p>By using a high value for the L1 penalty factor, many weights in the logistic regression
will be shrunk to 0, meaning the model will be smaller to store and faster to evaluate.
This is more suited to resource constrained environments (space or time).</p>
<p>Time constraints meant I only completed the R/Java integration but not the prediction
itself; it predicts the static string "Java" (using Java; woo!).</p>
<h3>Rock Paper Scissors</h3>
<p>This is included for amusement only; try the options!</p>
<p>The "Rock Paper Scissors" algorithm is trivial, and a nod to
<a href="http://www.gametheory.net/popular/reviews/Simpsons.html">The Simpsons</a>.</p>
                                    ')),
      tabPanel("Bibliography", HTML('
        <ol>
          <li><a href="http://cran.r-project.org/web/packages/tm/tm.pdf">http://cran.r-project.org/web/packages/tm/tm.pdf</a></li>
          <li><a href="http://www.slideshare.net/jaganadhg/elements-of-text-mi">http://www.slideshare.net/jaganadhg/elements-of-text-mi</a></li>
          <li><a href="http://beyondvalence.blogspot.com/search/label/text%20mining">http://beyondvalence.blogspot.com/search/label/text%20mining</a></li>
          <li><a href="http://stackoverflow.com/questions/8161167/what-algorithm-i-need-to-find-n-grams">http://stackoverflow.com/questions/8161167/what-algorithm-i-need-to-find-n-grams</a></li>
          <li><a href="http://shiny.rstudio.com/articles/reactivity-overview.html">http://shiny.rstudio.com/articles/reactivity-overview.html</a></li>
          <li><a href="http://stackoverflow.com/questions/21921422/row-sum-for-large-term-document-matrix-simple-triplet-matrix-tm-package">http://stackoverflow.com/questions/21921422/row-sum-for-large-term-document-matrix-simple-triplet-matrix-tm-package</a></li>
          <li><a href="http://stackoverflow.com/questions/17703553/bigrams-instead-of-single-words-in-termdocument-matrix-using-r-and-rweka">http://stackoverflow.com/questions/17703553/bigrams-instead-of-single-words-in-termdocument-matrix-using-r-and-rweka</a></li>
          <li><a href="http://stackoverflow.com/questions/6025051/extracting-indices-for-data-frame-rows-that-have-max-value-for-named-field">http://stackoverflow.com/questions/6025051/extracting-indices-for-data-frame-rows-that-have-max-value-for-named-field</a></li>
          <li><a href="http://stackoverflow.com/questions/24191728/documenttermmatrix-error-on-corpus-argument">http://stackoverflow.com/questions/24191728/documenttermmatrix-error-on-corpus-argument</a></li>
          <li><a href="http://stackoverflow.com/questions/7804816/how-to-create-a-dictionary-hash-table-by-iterating-through-a-column">http://stackoverflow.com/questions/7804816/how-to-create-a-dictionary-hash-table-by-iterating-through-a-column</a></li>
          <li><a href="http://en.wikipedia.org/wiki/Katz%27s_back-off_model">http://en.wikipedia.org/wiki/Katz%27s_back-off_model</a></li>
          <li><a href="http://www.gametheory.net/popular/reviews/Simpsons.html">http://www.gametheory.net/popular/reviews/Simpsons.html</a></li>
        </ol>
                                    ')),
      tabPanel("About", p(HTML('Code can be found at <a href="https://github.com/oodeng/capstone-coursera">https://github.com/oodeng/capstone-coursera</a>.')))
    )
  )
))