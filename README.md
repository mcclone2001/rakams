# README

## Como instalar
Descargar este repo, instalar las gemas, descargar imagenes de docker
```
sudo apt-get install libsqlite3-dev
git clone [ruta] directorio
cd directorio
bundle install
sudo docker-compose pull
```

## Como usar
Iniciar zookeeper y kafka
```
sudo docker-compose up zookeeper kafka
rails c
```

## Atención!
Los modelos deben generarse con --primary-key-type=string

P.ej.:
```
rails g model User [tus campos] deleted_at:datetime:index --primary-key-type=string
```

## Que hace?
* Agrega generators para Karafka Responders
```
rails g responder [Nombre] [topico]
```

* Agregar generators para Karafka Consumers
```
rails g consumer [Nombre] [topico]
```

* Agrega metodo instrument(event,payload) block para
    * Dispara metricas de StatsD
    * Genera logs para agregacion

* Activa acts_as_paranoid por default

* Sobrecarga modelos para usar UUID en lugar de ids secuenciales

## TO DO
* agregar cache para recursos externos (empezar con active resource)
    - polling
    - events
* sobrecargar ApplicationRecord para agregar eventos estandar para que otros servicios puedan cachear
    Altas
    Bajas
    Cambios
* verificar la destruccion del consumer generator, especificamente la modificacion que hace a karafka.rb
* agregar seguridad (por token)
* agregar config por default para statsd
* incluir profiler (https://github.com/MiniProfiler/rack-mini-profiler)
* sobrecargar model generator con --primary-key-type=string  (No es posible por el momento https://github.com/rails/rails/pull/13972)

* arrastrar el id de request que vienen en el header a los responders para llevar la trazabilidad (ponerlo en header para karafka X_REQUEST_ID, rails pone request.request_id disponible para los controllers si en la peticion viene el header X_REQUEST_ID, si no, lo genera aleatoriamente)
* convertir este proyecto a gema para que si se actualiza algo solo se actualice la gema en los proyectos que salgan de este