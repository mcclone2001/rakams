# README

## Como instalar
Descargar este repo, instalar las gemas, descargar imagenes de docker (esto ultimo tarda +30mins)
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

* arrastrar el id de request que vienen en el header a los responders para llevar la trazabilidad (ponerlo en header para karafka X_REQUEST_ID, rails pone request.request_id disponible para los controllers si en la peticion viene el header X_REQUEST_ID, si no, lo genera aleatoriamente)

* convertir este proyecto a gema para que si se actualiza algo solo se actualice la gema en los proyectos que salgan de este

* sobrecargar model generator con --primary-key-type=string  (No es posible por el momento https://github.com/rails/rails/pull/13972)


## Comprobar Debezium
Asegurarse de descomentar esta línea en el archivo pgdata/postgresql.conf, si la carpeta no existe inicia y deten postgres (docker-compose up db)
```
178: wal_level = logical
233: max_wal_senders = 1
238: max_replication_slots = 1
```

y agregar esta linea al archivo pgdata/pg_hba.conf
```
host    replication     postgres        0.0.0.0/0            trust
```

Iniciar Postgres, Kafka, Zookeeper y Debezium Connect
```
docker-compose build connect && docker-compose up db connect kafka zookeeper
```

Registrar el conector
```
curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" http://localhost:8083/connectors/ -d @docker-compose/debezium-jdbc/config.json
```

verifica que el conector fue registrado
```
curl -H "Accept:application/json" localhost:8083/connectors/
```

listar topicos
```
docker run -it --rm --env ZOOKEEPER_CONNECT=zookeeper:2181 --net rakams_kafka-net debezium/kafka list-topics
```

para ver todos los mensajes en un topico
```
docker run -it --rm --env ZOOKEEPER_CONNECT=zookeeper:2181 --env KAFKA_BROKER=kafka:9092 --net rakams_kafka-net debezium/kafka watch-topic -a consultation_requests
```

para los mensajes en un topico mientras llegan
```
docker run -it --rm --env ZOOKEEPER_CONNECT=zookeeper:2181 --env KAFKA_BROKER=kafka:9092 --link debezium-aws-rds-config-scripts_zookeeper_1:zookeeper --link debezium-aws-rds-config-scripts_kafka_1:kafka --net debezium-aws-rds-config-scripts_default debezium/kafka watch-topic consultation_requests
```


Quedo mal? Borra el conector.
```
curl -i -X DELETE -H "Accept:application/json" localhost:8083/connectors/consultation-request-connector
```
