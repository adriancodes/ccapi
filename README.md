# Appointment API
This is a sample project which demonstrates how to build an API using Ruby On Rails. The application imports a cvs file containing dummy data and seeds the database.

__Built with: Ruby 2.3.0 & Rails 4.2.6__

# EndPoint

The API endpoint can be found at this url: [http://api.adrianmartin.org](http://api.adrianmartin.org)

# DESIGN NOTES

* I created this API using Rails with the ```--api``` flag since the API is not going to use any browser functions.
* I'm using RSpec for testing the API calls
* I deployed this application to AWS Elastic Beanstalk with a PostgreSQL RDS for the backend
* I decided to let the user enter the dates using the same format found in the CSV file but I transform them in the application.
* Since this is for testing purposes, I did not impliment any security features or API versioning schemes.
* The API requires you make requests with the Content-Type header set to ```application/json```

# ADDED GEMS

* RSpec : API Testing
* PG : PostgreSQL in Production
* Puma : Elastic Beanstalk Deployment Instance Running Puma

# Testing API

I recommend you use an API testing tool like Postman or simliar chrome extension

**When testing the API make sure your request headers include**

```Content-Type: 'application/json'```

## Exposed API Calls

### INDEX
| URI | Method | Description |Status Code |
|------------------------------------------|---|----|---------|
| http://api.adrianmartin.org/|  displays basic information |GET| 200|

### LIST
| URI | Method | Description |Status Code |
|------------------------------------------|---|----|---------|
| http://api.adrianmartin.org/appointments/| Returns all the resources | GET | 200, 404|
| http://api.adrianmartin.org/appointments/:id| Returns one resource | GET | 200, 404|
| [http://api.adrianmartin.org/appointments?start_time=11/8/13 13:45&end_time=11/11/13 11:00](http://api.adrianmartin.org/appointments?start_time=11%2F8%2F13%2013%3A45&end_time=11%2F11%2F13%2011%3A00)| Returns filtered resource  | GET | 200, 404, 422|

### CREATE
| URI | Method | Description |Status Code |
|------------------------------------------|---|----|---------|
| http://api.adrianmartin.org/appointments/|  posts a new resource |POST| 201, 400, 422|

**Allowd Fields**


|Field      | Type   |Example |
|------------|-------|------|
|first_name | string |"John"|
|last_name  | string |"Snow"|
|start_time | string |"11/5/17 8:00"|
|end_time   | string |"11/5/17 8:05"|
|comment    | string |"Knows nothing..."|

**Properly Formatted JSON Body**

```
    {
      "first_name": "John",
      "last_name": "Snow",
      "comment": "Knows nothing...",
      "start_time": "11/5/17 8:00",
      "end_time": "11/5/17 8:05"
    }
```


### UPDATE
| URI | Method | Description |Status Code |
|------------------------------------------|---|----|---------|
| http://api.adrianmartin.org/appointments/:id|  updates a new resource |PUT, PATCH| 204, 400, 422|

**Allowd Fields**


|Field      | Type   |Example |
|------------|-------|------|
|first_name | string |"John"|
|last_name  | string |"Snow"|
|start_time | string |"11/5/17 8:00"|
|end_time   | string |"11/5/17 8:05"|
|comment    | string |"Knows nothing..."|

**Properly Formatted JSON Body**

```
    {
      "first_name": "John",
      "last_name": "Snow",
      "comment": "Knows nothing...",
      "start_time": "11/5/17 8:00",
      "end_time": "11/5/17 8:05"
    }
```

### DELETE
| URI | Method | Description |Status Code |
|------------------------------------------|---|----|---------|
| http://api.adrianmartin.org/appointments/:id|  deletes a resource |POST| 200, 404|

