# Personal Data Indicators (PD Indicators) in OpenAPI specifications

Transparency is about revealing information about the processing of
personal data to the data subject. However, an OpenAPI specification
describes a RESTful API as a whole, including many details unrelated to
the processing of personal data. Hence, the first step towards a
transparency-specific OpenAPI extension consists of identifying where
and how personal data becomes relevant and where respective transparency
information is thus to be incorporated in an OpenAPI specification
document. In the following, we refer to those parts of the specification
that describe consumed or exposed personal data as *PD indicators*
herein. [1]

The most relevant part with regards to *PD indicators* is the `paths`
section. All routes and requests provided by the described service are
listed here. In the paths object, instances of `pathItem` can be
defined, describing a single URL a service accepts requests for. Such a
`pathItem` can consist of several `operations` (GET, POST, etc.) that
map to HTTP request methods. For each operation, in turn, all entities
that make up a request and its response can be described. These include
request bodies, responses, headers, cookies and parameters, whereas
OpenAPI consolidates path parameters (e.g. `domain.tld/{user_id}`),
query parameters (e.g `GET` parameters like `/path?user_id=123`),
headers and cookies under the `Parameter` class.

**Data locations:** *PD indicators*
a service *consumes* may only appear in the requestBody or in all types
of parameters; *PD indicators* a service *exposes* can be found in a
response or a header parameter. If these locations are considered, any
potentially consumed and exposed *PD indicator* of an API can be covered
by our extension. While there are several constellations that are to be
considered, our extension utilizes one important fact: Independently
from where *PD indicators* are defined, the entity itself is always
described in the same way: using a `schema` object. A `schema` in
OpenAPI is encoded as a *JSON Schema* that is used in an extended form
by the OpenAPI specification. It allows for the description of data
types and their structure.

In OpenAPI a `schema` is mostly wrapped in a `MediaType` object which
itself is wrapped in a `content` object, the latter of which can be
present for all entities listed above. Only in the case of `parameters`,
the `schema` *may* be provided directly within the `parameter` object
without incorporating a content and MediaType object. This is due to the
simple format of parameters expressed and passed via the path. In all
other cases (`requestBody`, `response` etc.) the schema must be wrapped
by media types within the `content` object. A `schema` may contain
`properties`, which themselves can be described via a `schema`.

Hence, while there are plenty of constellations, the declaration of data
itself does not differ between these locations. While many locations
need to be parsed, the extracting of *PD indicators* from all of these
follows the same logic. Only the context and dependencies can differ.

**Reusable components:** Under the components section of OpenAPI
documents, several entities can be defined for being (multiply)
referenced in the specification. These components thus also need to be
considered while locating *PD indicators*. References within OpenAPI
documents allow – following the JSON Reference specification –
referencing other values in a JSON document, which are yielded as they
are. Reusable components can thus be approached as if they were defined
in place and all previously mentioned rules apply. It must, however, be
ensured that only components which are actually referenced are
considered.

**Extension objects:** OpenAPI extensions provide a concept to describe
vendor-specific information in many formats, including custom objects.
These are providing developers with a flexible way to express further
custom information in an OpenAPI document. In theory, *PD indicators*
could also be encoded within extension objects. However, such practice
is not desirable due to the lack of standardization. Moreover, the
OpenAPI specification states that “extensions may or may not be
supported by the available tooling” . Therefore, *PD indicators* within
extension objects are beyond the scope of this paper.


---
[1] For the sake of understanding and clarity: The OpenAPI
specifications may under no circumstances contain personal data records
(“Jane Doe”), but only *PD indicators* (“Name”).
