## SEMAROFO CON PIC 16F887 EN LENGUAJE ENSAMBLADOR

Este programa simula el control de un par de semaforos en un cruce, a petición del profesor se integraron un par de botones, que realizan condiciones especificas al presionar uno u otro, y un tercer caso al presionar ambos. 

![imagen circuito base](/assets/images/circuito_b.jpeg)

El ciclo del semaforo corre de manera continua, mantiene la posición en verde o rojo por 10 segundos, posteriormente realizará 4 parpadeos de un segundo cada uno , para luego pasar al color amarillo por 3 segundos y posteriomente al color opuesto por otros 10 segundos más. Este ciclo se repetira constantemente si no hay intervención de alguno de los botones. 

Al presionar el boton 1, indica al programa terminar el ciclo en curso para posteriormente bloquear la combinación siguiente: Color verde para el semaforo 1 y color rojo para el semaforo 2. Mientras este boton se mantenga presionado esta posición se mantendrá, por lo que no permitirá el ciclo continuo del semaforo. 

Al presionar el boton 2, indica al porgrama terminar el ciclo en curso para posteriormente bloquear la combinación siguiente: Color rojo para el semaforo 1 y color verde para el semaforo 2. Mientras este boton se mantenga presionado esta posición se mantendrá, por lo que no permitirá el ciclo continuo del semaforo. 

Cuando ambos botones se mantienen presionados el ciclo continuo se reactiva como si ninguno se encontrará presionado. 