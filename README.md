# Classroom
Classroom is a streamlined web API that showcase the development of online course management services. The project is built on **Ruby on Rails**, provides API endpoints for retrieving a course list, viewing course details, creating a course with chapters and units, updating a course, its chapters, and units, and deleting a course.

## Prerequisite
- Ruby version: 3.2.0
- Rails version: 7.11

## How to run the server
To run the server on your local machine, ensure that you have Ruby `3.2.0` and PostgreSQL installed.

1. Clone the repository to your local machine
2. Navigate to the project directory.
3. Install dependencies. 
  
    ```bash
    bundle install
    ```

4. Set up the database. 
   
    ```bash
    rails db:create
    rails db:migrate
    ```

5. start the server. 

    ```bash
    rails server
    ```

The API will be accessible at http://localhost:3000.

## Dependencies

- `pg`: PostgreSQL database adapter.
- `will_paginate`: Pagination library.
- `jbuilder`: JSON objects generator
- `rspec`: Ruby testing framework.
- `factory_bot`: Library for creating test data.
- `annotate`: A comment summarizing the current schema.

## Project Structure
The API server is built around the MVC pattern. When a request is received, it first goes to the controller, which handles incoming requests, invokes corresponding services to process data, and calls the view to present information in JSON format if necessary. The model defines the data structure, dependencies, and validation. The service contains data processing logics, and the view includes data presentation.

All tests, including integration and unit tests, reside in the spec directory.

```
├── app/
│   ├── controllers/
│   ├── models/
│   ├── services/
│   └── views/
├── config/
├── db/
│   ├── migrate/
│   └── schema.rb
├── spec
└── Gemfile
```


## API Endpoints Summary

- Course List
  - Endpoint: `GET /api/v1/courses?page=?&number=?`
  - Description: Retrieve a list of courses with pagination support.
- Create a Course Details
  - Endpoint: `POST /api/v1/courses`
  - Description: Create a course, chapters, and units in a single request.
  - Payload example:

    ```json
    {
      "course": {
        "name": "Ruby on Rails",
        "lecturer": "Test",
        "description": "Test",
        "chapters": [
          {
            "name": "Chapter A",
            "units": [
              {
                "name": "Hello Word",
                "description": "",
                "content": "Create a Hello World"
              }
            ]
          }
        ]
      }
    }
    ```
- Get a Course Details 
  - Endpoint: `GET /api/v1/courses/:id`
  - Description: Retrieve details of a specific course, including its chapters and units.
- Edit a Course Details
  - Endpoint: `PUT /api/v1/courses/:id`
  - Description: Update details of a specific course, including inserting or deleting chapters and units.
  - Payload example:

    ```json
    {
      "course": {
        "id": 1,
        "name": "Ruby on Rails",
        "lecturer": "Test",
        "description": "Test",
        "chapters": [
          {
            "id": 1,
            "name": "Chapter A",
            "units": [
              {
                "id": 1,
                "name": "Hello Word",
                "description": "",
                "content": "Create a Hello World"
              }
            ]
          },
          {
            "id": 2,
            "name": "Chapter B",
            "units": [
              { // delete 
                "id": 2,
                "name": "Unit B-1",
                "description": "",
                "content": "Old content",
                "_deleted": true 
              },
              { // insert
                "name": "Unit B-1",
                "description": "",
                "content": "New content" 
              }
            ]
          }
        ]
      }
    }
    ```
- Delete a Course
  - Endpoint: `DELETE /api/v1/courses/:id`
  - Description: Delete a specific course, cascading down to associated chapters and units.

## Implementation Details

### Course List 
Clients can retrieve a paginated list of courses using this endpoint. To mitigate the load on the database, pagination is implemented with the `will_paginate` gem, limiting the maximum number of courses to `30` per page. Clients can control pagination through the page and number parameters.

### Create a Course Details
This endpoint creates a course, chapters, and units simultaneously. The process involves two stages. First, the `CourseParamsValidator` validates the course parameters, providing clear and customized error messages for any invalid input. Second, the `CourseFactory` creates the course, chapters, and units. The sorting of chapters and units is determined by the index of the array in the course parameters.

### Get a Course Details
Clients can fetch details of a specific course, including its chapters and units, using this endpoint. The presentation is in JSON format, using `jbuilder`. Chapters and units are sorted in ascending order, with sorting handled in the application layer to optimize database queries rather than using order sql clause. The order sql clause will cause N+1 problems.

### Edit a Course Details
This endpoint allows clients to edit course, chapter, and unit information, including insertion or deletion of chapters and units. Similar to the creation process, it involves two stages. First, the `CourseParamsValidator` validates the course parameters, ensuring that the payload includes all relevant chapters and units. Second, the `CourseUpdater` iterates through the payload, updating, inserting, or deleting objects based on their attributes. All operations are wrapped in an SQL transaction to maintain ACID compliance.

### Delete a Course
Clients can delete a course by its ID, triggering automatic cascading deletion of associated chapters and units. This is achieved through defined dependencies and destroy callbacks in the models.

## Comment Philosophy
Comments are used to explain complex or non-intuitive code sections. Tools like `annotate` are facilitate to generate schema comments for easy reference to table columns. 

## Challenges and Solutions

### Insert Many Chapters and Units 
**Challenge**: 

It's challenging to reduce insertion queries for chapters and units, especially when dealing with a large number of chapters and units. The current approach in `CourseFactory` results in a significant number of queries, and optimizing this process is an ongoing consideration.

**Solution**: 

Consider implementing batch inserts using the `activerecord-import` gem. Grouping chapters and units by course and executing a single bulk insert can significantly improve the insertion process.

### Update, Insert and Delete in One place
**Challenges**: 

Managing update, insert, and delete operations in a single endpoint introduces complexity, especially when dealing with a large number of chapters and units for different operations. The current approach in `CourseUpdater` results in a significant number of queries.

**Solution**: 

Separate the responsibilities of updating, inserting, and deleting into individual endpoints.This not only simplifies the logic but also allows for better maintainability and scalability.

### Caching
**Challenge**: 

Implementing caching for endpoints like `#index` and `#show` can enhance system performance, but managing data freshness and cache eviction, especially for a course details endpoint with substantial data, presents challenges.

**Solution**:

Use a `TTL` for cache expiration. Additionally, consider `LRU` as cache eviction policy to avoid cold cache stays in memory for a long period of time.

### System Availabitiy
**Challenge**: 

To enhance system availability, adding a load balancer to distribute traffic among multiple API servers is crucial. This ensures better fault tolerance and scalability.

**Solution**: 

Integrate a load balancer into the system architecture such as `NGINX` to distribute incoming requests among multiple API servers. This setup improves system availability by preventing a single point of failure. Additionally, consider implementing health checks and auto-scaling to adapt to varying levels of traffic.

