// components/ApolloWrapper.tsx
"use client";

import { ApolloProvider } from "@apollo/client";
import client from "@/lib/apolloClient";


// Prop definition (usually children)
interface ApolloWrapperProps {
	children: React.ReactNode;
}

export default function ApolloWrapper({ children }: ApolloWrapperProps) {
	return (
	  <ApolloProvider client={client}>
		{children}
	  </ApolloProvider>
	);
  }