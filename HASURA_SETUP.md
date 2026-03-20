# Hasura GraphQL + PostgreSQL Setup Guide

## Prerequisites

Before starting, ensure you have:
- **Docker** installed ([Download Docker](https://www.docker.com/products/docker-desktop))
- **Docker Compose** (included with Docker Desktop)
- **Git** installed on your system

---

## Step-by-Step Installation

### Step 1: Start Docker Services

1. Navigate to your project directory:
```bash
cd c:\Users\stadmin\Desktop\nextintern\internhub
```

2. Start Hasura and PostgreSQL containers:
```bash
docker-compose up -d
```

3. Verify containers are running:
```bash
docker-compose ps
```

You should see both `internhub_postgres` and `internhub_hasura` running.

---

### Step 2: Access Hasura Console

1. Open your browser and go to:
```
http://localhost:8080/console
```

2. Enter the Admin Secret when prompted:
```
admin_secret_key
```

---

### Step 3: Create Your First Table

1. In Hasura Console, go to **Data** tab
2. Click **Create Table**
3. Create a sample table:

**Example: Create a `users` table**
```sql
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

Or use the UI to create:
- Table Name: `users`
- Columns:
  - `id` (Int, Auto-increment, Primary Key)
  - `name` (Text, Required)
  - `email` (Text, Required, Unique)
  - `created_at` (Timestamp, Default: now())

---

### Step 4: Enable GraphQL API

1. After creating the table, Hasura automatically enables GraphQL
2. Go to **API** tab to test GraphQL queries
3. Try this sample query:
```graphql
query GetUsers {
  users {
    id
    name
    email
    created_at
  }
}
```

---

## Step 5: Connect Next.js to Hasura

### Install Apollo Client (Optional but Recommended)

```bash
npm install @apollo/client graphql
```

### Create a GraphQL Hook (Next.js Example)

Create `lib/apolloClient.ts`:

```typescript
import { ApolloClient, InMemoryCache, HttpLink } from '@apollo/client';

const apolloClient = new ApolloClient({
  ssrMode: typeof window === 'undefined',
  link: new HttpLink({
    uri: process.env.NEXT_PUBLIC_GRAPHQL_ENDPOINT || 'http://localhost:8080/v1/graphql',
    credentials: 'include',
  }),
  cache: new InMemoryCache(),
});

export default apolloClient;
```

### Query from Next.js Component

```typescript
import { useQuery, gql } from '@apollo/client';

const GET_USERS = gql`
  query GetUsers {
    users {
      id
      name
      email
      created_at
    }
  }
`;

export default function Users() {
  const { loading, error, data } = useQuery(GET_USERS);

  if (loading) return <p>Loading...</p>;
  if (error) return <p>Error: {error.message}</p>;

  return (
    <div>
      {data?.users.map((user: any) => (
        <div key={user.id}>
          <h3>{user.name}</h3>
          <p>{user.email}</p>
        </div>
      ))}
    </div>
  );
}
```

---

## Common Commands

### View Logs
```bash
docker-compose logs -f hasura
docker-compose logs -f postgres
```

### Stop Services
```bash
docker-compose down
```

### Stop and Remove Volumes (Reset Database)
```bash
docker-compose down -v
```

### Restart Services
```bash
docker-compose restart
```

### Access PostgreSQL CLI
```bash
docker exec -it internhub_postgres psql -U postgres -d internhub_db
```

---

## Environment Variables

The `.env.local` file contains:

| Variable | Default | Purpose |
|----------|---------|---------|
| `POSTGRES_USER` | postgres | Database user |
| `POSTGRES_PASSWORD` | postgres | Database password |
| `POSTGRES_DB` | internhub_db | Database name |
| `HASURA_ADMIN_SECRET` | admin_secret_key | Hasura admin password |
| `HASURA_JWT_SECRET` | HS256 key | JWT secret for authentication |
| `HASURA_UNAUTHORIZED_ROLE` | anonymous | Role for unauthenticated users |
| `NEXT_PUBLIC_GRAPHQL_ENDPOINT` | http://localhost:8080/v1/graphql | GraphQL endpoint |

**⚠️ IMPORTANT:** Change these values in production!

---

## Useful Hasura Features

### 1. Define Relationships
- Create relationships between tables (1:1, 1:N relationships)
- Enables nested queries

### 2. Set Permissions
- Control who can read/write data
- Role-based access control (RBAC)

### 3. Triggers and Event Webhooks
- Auto-execute webhooks on data changes
- Great for real-time notifications

### 4. Database Migrations
- Track schema changes with version control
- Use Hasura CLI for migrations

---

## Troubleshooting

### Port Already in Use
If port 5432 or 8080 is in use:
1. Change ports in `docker-compose.yml`
2. Or stop the conflicting service: `docker stop <container_id>`

### Connection Refused
1. Ensure PostgreSQL is healthy: `docker-compose ps`
2. Check logs: `docker-compose logs postgres`
3. Wait a few seconds for PostgreSQL to start

### Hasura Console Not Loading
1. Clear browser cache
2. Check if admin secret is correct
3. Verify Hasura is running: `docker ps | grep hasura`

---

## Next Steps

1. **Define Your Schema** - Create all tables in Hasura
2. **Set Up Relationships** - Connect related tables
3. **Configure Permissions** - Restrict data access by role
4. **Integrate with Next.js** - Use Apollo Client or Fetch API
5. **Deploy** - Use Docker Compose in production with proper security

---

## Useful Resources

- [Hasura Documentation](https://hasura.io/docs/latest/index/)
- [GraphQL Tutorial](https://graphql.org/learn/)
- [Apollo Client Docs](https://www.apollographql.com/docs/react/)
- [PostgreSQL Docs](https://www.postgresql.org/docs/)
