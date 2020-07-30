# README

## Como instalar
Descargar este repo, instalar las gemas, descargar imagenes de docker
```
git clone [ruta] directorio
cd directorio
bundle install
docker-compose pull
```

## Como usar
Iniciar zookeeper y kafka
```
docker-compose up zookeeper kafka
rails c
```

## Atención!
Los modelos deben generarse con --primary-key-type=string

P.ej.:
```
rails g model User phone:string:uniq password:string --primary-key-type=string
rails g migration AddDeletedAtToUser deleted_at:datetime:index
```

## Que hace?
Agrega generators para Karafka Responders
Dispara metricas de StatsD
Genera logs para agregacion
Sobrecarga modelos para usar UUID en lugar de ids secuenciales

## TO DO
* agregar generators para Karafka Consumers
* agregar config por default para statsd
* incluir profiler (https://github.com/MiniProfiler/rack-mini-profiler)
* sobrecargar model generator con --primary-key-type=string  (No es posible por el momento https://github.com/rails/rails/pull/13972)

* arrastrar el id de request que vienen en el header a los responders para llevar la trazabilidad
* considerar convertir este proyecto a gema para que si se actualiza algo solo se actualice la gema en los proyectos que salgan de este