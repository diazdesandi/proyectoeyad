# Se declaran las librerias a utilizar 
library(Amelia)
library(e1071)
library(caret)
library(caTools)

# Se almacena los datos del archivo TR_VIVIENDA02.csv en la variable ep
ep <- read.csv('TR_VIVIENDA02.csv')

# Declaramos una semilla de 100
set.seed(100)

# Se selecciona las columnas a utilizar 
vivienda <- ep[c(4,40,88)]

# Restringimos a un ingreso menor de $100,000 ya que mayores a esa cantidad usan de manera correcta los servicios de recolección de basura
vivienda <- vivienda[vivienda$INGTRHOG < 100000,]

# Se realiza un proceso de limpieza sobre los datos a utilizar
missmap(vivienda)

# Se valida que los datos no contengan datos nulos
vivienda <- na.omit(vivienda)

# Se realiza un segundo proceso de limpieza con la finalidad de evitar errores al momento de entrenar nuestro modelo
missmap(vivienda)

# Se indica que usaremos el campo destino basura para crear nuestras clases
vivienda$DESTINO_BASURA = factor(vivienda$DESTINO_BASURA, levels = c(1,2,3,4,5,6))

# Indicamos que nuestro modelo usara un 70% de datos de entrenamiento y un 30% de prueba
split = sample.split(vivienda$DESTINO_BASURA, SplitRatio = 0.7)

# Se declaran los datos de entrenamiento
traindata = subset(vivienda, split == TRUE)

# Declaramos los datos de prueba
testdata = subset(vivienda, split == FALSE)

# Se elimina la variable donde almacenaba los datos
rm(split)

# Entrenamos nuestro modelo bayesiano
nbmodel <- naiveBayes(x = traindata, y = traindata$DESTINO_BASURA, SplitRatio = 0.70)

# Comprobamos que no contenga errores
nbmodel

# Indicamos nuestros datos de prediccion
pred <- predict(nbmodel,testdata[,-3])
tab <- table(testdata[,2], pred, dnn = c("Actual", "Predicted"))

# Mostramos nuestro modelo de predicción
confusionMatrix(tab)

# Limpiamos la memoria
gc()
# Se muestra de manera gráfica nuestros datos de entrenamiento
plt  <- ggplot(traindata, aes(x=MUN, y=INGTRHOG, color = traindata$DESTINO_BASURA))
# Utilizando la libreria ggplot para mostrar la grafica, vamos a utilizar el subset de los datos de entrenamiento del modelo creados en el split, a continuacion, colocamos los datos de las columnas a mostrar en el eje X como en el eje Y, se van a mostrar dependiendo el destino de la basura.
+ labs(title = 'Ingresos del hogar por municipio', x="Municipios",y="Ingresos x hogar", color='Destino de la basura' )

# A continuacion, se va a utilizar la funcion para el grafico de puntos mas la estructura anterior creada.
trainplt <- plt + geom_jitter()
# Mostrar grafica.
trainplt

# Se muestra de manera grafica nuestros datos de prueba
plat  <- ggplot(testdata, aes(x= MUN, y= INGTRHOG,color = testdata$DESTINO_BASURA))

# utilizando la librería ggplot para mostrar la gráfica, vamos a utilizar el subset de los datos de prueba del modelo creados en el split, a continuacion, colocamos los datos de las columnas a mostrar en el eje X como en el eje Y, se van a mostrar dependiendo el destino de la basura
# Utilizando labs vamos a colocar el nombre de los labels a los ejes y a la grafica
+ labs(title ='Ingresos del hogar por municipio', x="Municipios",y="Ingresos x hogar", color='Destino de la basura' )
testplt <- plat + geom_jitter()
Testplt
