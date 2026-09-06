# Problem_66-fixed_priority_arbiter
A Fixed-Priority Arbiter is a digital circuit that grants access to a single shared resource (like a memory bus or data bus) among multiple competing requestors based on a strict, unchangeable hierarchy.

In a 4-requester design, 4 separate blocks (e.g., CPU, DMA, Peripheral 1, Peripheral 2) can request the resource at the exact same time. The arbiter looks at all incoming requests and immediately awards access to the active requestor with the highest hardcoded priority.

Priority Hierarchy (Highest to Lowest)In a standard 4-requester implementation, priority is typically assigned from bit 0 to bit 3 (or vice versa):
Request 0 (req[0]) --> Priority 1 (Highest): Wins every time it asks, no matter who else is asking.
Request 1 (req[1]) --> Priority 2: Wins only if req[0] is NOT requesting.
Request 2 (req[2]) --> Priority 3: Wins only if both req[0] and req[1] are NOT requesting.
Request 3 (req[3]) --> Priority 4 (Lowest): Wins ONLY if nobody else is requesting.
