# Contact Importer

This is a Ruby on Rails 7 application with PostgreSQL database, there are two ways to run it, first one running locally and second one running with docker.

The files to test is in the folder `files` in the root of application, there are two files `MOCK_DATA_10.csv` y `MOCK_DATA_500.csv`, the first one could be used to test each of validate cases of columns, the second one has 500 records.

## Running application locally.

### Prerequisites

* Ruby version 3.1.2
* Rails version 7.0.4
* PostgreSQL database.

### Installation

1. Clone the project from Github: 
```bash
git clone https://github.com/Andres23Ramirez/contact-importer
```
2. Install dependencies: 
```bash
bundle install
```

### Configuration

1. Update config/database.yml with your PostgreSQL database settings:

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: your_postgres_username
  password: your_postgres_password
  host: localhost

development:
  <<: *default
  database: app_name_development

test:
  <<: *default
  database: app_name_test

production:
  <<: *default
  database: app_name_production
  username: app_name
  password: <%= ENV['APP_NAME_DATABASE_PASSWORD'] %>
```

### Creating the database

* Run the following command to create the database: `rails db:create`

### Running the migrations

* Run the following command to run the migrations: `rails db:migrate`

### Seeding the database
* Run the following command to populate the database: `rails db:seed`

### Starting the server
* Run the following command to start the server: `rails server`

Your application should now be up and running on [http://localhost:3000/]().

## Running application with docker.

This is a Rails 7 app with a Postgres database that runs inside a Docker container. The Docker Compose configuration spins up two containers: one for the Rails app and another for the Postgres database.

### Prerequisites

* Docker
* Docker Compose

### Installation
1. Clone this repository to your local machine:
```sh
git clone https://github.com/Andres23Ramirez/contact-importer.git
cd contact-importer
```
2. Build the Docker images and start the containers:
```sh
docker-compose up --build
```
3. Create the database and run migrations:
```sh
docker-compose run web rails db:create db:migrate
```
4. Seed the database:
```sh
docker-compose run web rails db:seed
```
5. Open your web browser and go to [http://localhost:3000]() to see the Rails app in action.

### Usage
To start the app, run:

```sh
docker-compose up
```
To stop the app, press `Ctrl+C` in the terminal.

To run Rails commands inside the container, use the docker-compose run web command followed by the desired command, for example:

```sh
docker-compose run web rails console
```

### Troubleshooting
If you encounter any issues with the containers or the Rails app, try the following:

* Stop the containers and start them again:

```sh
docker-compose down
docker-compose up
```

* Check the logs for the web container:
```sh
docker-compose logs web
```
* If the database container fails to start, make sure that no other instances of Postgres are running on your system. You can also try changing the `ports` configuration in the `docker-compose.yml` file.

