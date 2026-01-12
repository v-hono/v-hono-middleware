# meiseayoung.hono_middleware

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
v install meiseayoung.hono
v install meiseayoung.hono_middleware
```

## Usage

### CORS Middleware

```v
import meiseayoung.hono
import meiseayoung.hono_middleware

fn main() {
    mut app := hono.Hono.new()

    app.use(hono_middleware.cors(hono_middleware.CorsOptions{
        origin: 'https://example.com'
        credentials: true
        allow_methods: ['GET', 'POST', 'PUT', 'DELETE']
    }))

    app.listen(':3000')
}
```

### Rate Limiting

```v
import meiseayoung.hono
import meiseayoung.hono_middleware

fn main() {
    mut app := hono.Hono.new()
    store := hono_middleware.MemoryStore.new()

    app.use(hono_middleware.rate_limit(hono_middleware.RateLimitOptions{
        store: store
        window_ms: 60000   // 1 minute
        limit: 100         // Max 100 requests
    }))

    app.listen(':3000')
}
```

### Request Validation

```v
import meiseayoung.hono
import meiseayoung.hono_middleware

fn main() {
    mut app := hono.Hono.new()

    app.post('/users',
        hono_middleware.validate_json(hono_middleware.v_object({
            'name': hono_middleware.v_string().required().min(2)
            'email': hono_middleware.v_string().required()
        })),
        fn (mut c hono.Context) http.Response {
            return c.json('{"message":"User created"}')
        }
    )

    app.listen(':3000')
}
```

## Dependencies

- `meiseayoung.hono` - Core framework

## License

MIT
