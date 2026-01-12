# hono.middleware

Middleware collection for v-hono-core framework.

## Features

- **CORS** - Cross-Origin Resource Sharing
- **Cookie** - Cookie parsing and management with signed cookies
- **Compress** - Gzip and deflate response compression
- **Rate Limit** - Request rate limiting
- **Validator** - Schema-based request validation
- **Logger** - Request logging

## Installation

```bash
v install hono
v install hono.middleware
```

## Usage

### CORS Middleware

```v
import hono
import hono.middleware

fn main() {
    mut app := hono.Hono.new()

    app.use(middleware.cors(middleware.CorsOptions{
        origin: 'https://example.com'
        credentials: true
        allow_methods: ['GET', 'POST', 'PUT', 'DELETE']
    }))

    app.listen(':3000')
}
```

### Rate Limiting

```v
import hono
import hono.middleware

fn main() {
    mut app := hono.Hono.new()
    store := middleware.MemoryStore.new()

    app.use(middleware.rate_limit(middleware.RateLimitOptions{
        store: store
        window_ms: 60000   // 1 minute
        limit: 100         // Max 100 requests
    }))

    app.listen(':3000')
}
```

### Request Validation

```v
import hono
import hono.middleware

fn main() {
    mut app := hono.Hono.new()

    app.post('/users',
        middleware.validate_json(middleware.v_object({
            'name': middleware.v_string().required().min(2)
            'email': middleware.v_string().required()
        })),
        fn (mut c hono.Context) http.Response {
            return c.json('{"message":"User created"}')
        }
    )

    app.listen(':3000')
}
```

## Dependencies

- `hono` - Core framework

## License

MIT
