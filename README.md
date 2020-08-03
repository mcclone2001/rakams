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
Agrega generators para Karafka Responders
Dispara metricas de StatsD
Genera logs para agregacion
Activa acts_as_paranoid por default
Sobrecarga modelos para usar UUID en lugar de ids secuenciales

## TO DO
* agregar generators para Karafka Consumers
* agregar config por default para statsd
* incluir profiler (https://github.com/MiniProfiler/rack-mini-profiler)
* sobrecargar model generator con --primary-key-type=string  (No es posible por el momento https://github.com/rails/rails/pull/13972)

* arrastrar el id de request que vienen en el header a los responders para llevar la trazabilidad
* considerar convertir este proyecto a gema para que si se actualiza algo solo se actualice la gema en los proyectos que salgan de este