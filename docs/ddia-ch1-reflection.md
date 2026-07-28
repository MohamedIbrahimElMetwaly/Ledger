# DDIA Chapter 1 Reflection — Reliability, Scalability, Maintainability

Martin Kleppmann frames every data system design around three concerns:

- Reliability (System works correctly under faults)
- Scalability (System handles growth in data, traffic and complexity)
- Maintainability (System stays workable for the team over time)

Looking back at Ledger's Section 8 trade-offs, I can now see that nearly every decision maps to one of these — I was making reliability, scalability, and maintainability calls without using those words.

## Reliability: (Most trade-offs prioritize reliability)

1. Transaction immutability eliminates an entire class of fault, partial in-place updates corrupting balances, by making dangerous operation impossible rather than trying to make it safe.
2. Synchronous balance updates guarantee that the user never see a stale balance, choosing correctness over write performance.
3. SELECT FOR UPDATE with read COMMITTED prevent lost updates from concurrent writes, the specific reliability gurantee system need without the overhead of SERIALIZABLE
4. SOFT DELETE ensures no financial can be record accidentaly destroyed

## Scalability:

-> The book's insight that scalability is not a binary propertey, you design for specific load parameters, not for abstract **scale**, Ledger's load profile is under 1000 transaction/day on a single Postgres instance.

-> Several trade-offs explicitly defer scalability work

1. Single currency over multi-currency
2. Synchronous over eventual consistency
3. Single database over distributed architecture

-> In each case, the current load doesn't justify the complexity, this maps directly to Kleppmann's point that premature scaling adds accidental complexity. The right time to add eventual consistency or sharding is when measured load demands it, not when imagined future load suggests it might.

## Maintainability

-> Klepmanns breaks maintainability into operability (easy to operate), simplicity (easy to understand) and evolvability (easy to change).

1. Choosing Java over Go or Rust prioritizes operability, the team ships faster in a familiar language, accepting higher memory usage.
2. Choosing double entry over simplified prioritizes evolvability, the data model is harder to build initially but doesn't need to be rewritten when split transactions are needed.
3. Flyway over Hibernate ddl-auto prioritze operability, every schema change is auditable and reproducible across environments

-> The trade-offs pattern I notice is that maintainability decisions often cost more upfront (more boilerplate, more complex inital model) but pay off over the lifetime of the system
