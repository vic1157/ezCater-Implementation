# ezCater-Implementation

Interaction Flow:

1. **User logs in** (handled by frontend/backend auth)
2. **Frontend** (Next.js) mounts the dashboard page
3. **Frontend** sends GraphQL queries (eg, for user data, recent addresses, saved restaurants) to the backend API endpoint
4. **Backend** (Rails/GraphQL) resolves these queries, fetches data from the database, and returns the data in the specified GraphQL format
5. **Frontend** receives the data and renders the UI components with it
6. **User interacts** (eg, types in the “Add delivery address” field, clicks “Order Now” on a recent address
7. **Frontend** updates its local state and/or sends GraphQL mutations to the backend to perform actions or trigger searches (like “Find Caterers)
