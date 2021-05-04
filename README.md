# TIRA: An OpenAPI Extension and Toolbox for GDPR Transparency in RESTful Architectures 

## Personal data indicators
To learn more about where personal data indicators in OpenAPI specifications may reside, see **[here](docs/PD_INDICATORS.md)**.

## Vocabulary
To learn more about our vocabulary used for the proposed OpenAPI extension, see **[here](docs/VOCABULARY.md)**.

## Example of *x-tira* in an OpenAPI document
We describe a `ToothbrushEvent` that can be shared with other utilizers via the example service from our paper. 

```yaml
openapi: "3.0.0"
x-tira: 
  utilizer:
    - name: "AWS"
      non_eu_country: true
      country: "UK"
info:
  version: "1.0.2"
  description: "This service can share health data with other health data services and insurances"
  title: "Health Data Sharing Service"
servers: 
  - url: "https://health.domain.tld"
paths:
  /{user_id}/toothbrush/share:
  parameters:
    - name: user_id
      in: "path"
      required: true
      description: "User ID of a Health Data Hub User" 
    get: 
      description: Get an array of Toothbrush Events for a given time interval.
      parameters:
      - name: startday
        in: "query"
        required: true
        description: "Start date of requested interval."
      - name: endday
        in: "query"
        required: true
        description: "End date of requested interval."
      responses:
        200:
          description: "Request successful."
          content: 
            application/json:
              schema:
                $ref: '#/components/schemas/ToothbrushEvent'
components:
  schemas:
    ToothbrushEvent:
      type: "object"
      required:
        - user_id
      properties:
        seconds:
          type: "integer"
        datetime:
          type: "string"
        user_id:
          type: "integer"
      x-tira: 
        retention-time:
          volatile: true
        special_category:
          category: "Health Data"
        purposes:
          yappl:
            '{
               "id":123,
               "preference":[
                  {
                     "rule":{
                        "purpose":{
                           "permitted": [ "FitnessData Sharing", "Health Insurance Bonus Program" ],
                           "excluded": [ ... ]
                        },
                        "utilizer":{
                           "permitted": [ ... ],
                           "excluded": [ ... ]
                        },
                        "transformation": [ ... ],
                        "valid_from":"2021-06-09T00:00:00.000Z",
                        "exp_date":"0000-01-01T00:00:00.000Z"
                     }
                  }
               ]
            }'
        profiling:
          reason: "Health profile based on series of health related behaviour."
        utilizer:
          - name: "MyFitnessPal"
            non_eu_country: false
          - name: "Strava"
            non_eu_country: true
            country: "USA"
        utilizer_category:
          - name: "Health Insurance Company"
            country: "Germany"
            non_eu_country: false
            type: "Insurance Company"
            sector: "Insurance"
            sub_sector: 
              - "Health Insurance"
              - "Health Tax"
```
