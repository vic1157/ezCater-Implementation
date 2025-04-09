// lib/apolloClient.ts
import { ApolloClient, InMemoryCache, createHttpLink, ApolloLink } from '@apollo/client';
import { setContext } from '@apollo/client/link/context';

// Connects to GraphQL API
const httpLink = createHttpLink({
  uri: process.env.NEXT_PUBLIC_GRAPHQL_ENDPOINT,
});

// Authorization header
const authLink = setContext((_, { headers }) => {
  let token: string | null = null;
  if (typeof window !== 'undefined') {
      token = localStorage.getItem('authToken'); 
  }

  // Return headers
  return {
    headers: {
      ...headers,
      authorization: token ? `Bearer ${token}` : "",
    }
  }
});

// Chain Links
const link = ApolloLink.from([authLink, httpLink]);

// Create Apollo Client instance
const client = new ApolloClient({
  // Use the chained link
  link: link,
  // Configure the cache strategy
  cache: new InMemoryCache(),
});

export default client;