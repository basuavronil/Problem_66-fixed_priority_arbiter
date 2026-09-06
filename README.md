## 4-Request Fixed-Priority Arbiter

### Module Overview
The `fixed_priority_arbiter` provides low-latency bus arbitration for up to four competing hardware blocks (`req[3:0]`). It resolves multi-master resource contention by enforcing a strict, hardcoded hierarchy where lower-indexed request lines take absolute precedence over higher-indexed ones.

---

### Priority Hierarchy & Logic Table
The priority hierarchy is statically mapped as:
$$\mathbf{req[0] > req[1] > req[2] > req[3]}$$

* **`req[0]`** — **Highest Priority:** Granted immediately whenever asserted, regardless of other inputs.
* **`req[1]`** — Granted only if `req[0]` is inactive.
* **`req[2]`** — Granted only if `req[0]` and `req[1]` are both inactive.
* **`req[3]`** — **Lowest Priority:** Granted only when it is the sole active request line.

#### Truth Table

| Request Vector (`req[3:0]`) | Grant Vector (`grant[3:0]`) | Winning Requestor | Condition / Selection Rule |
| :---: | :---: | :---: | :--- |
| `4'b0000` | `4'b0000` | *None* | Bus Idle (No active requests) |
| `4'bxxx1` | `4'b0001` | **`req[0]`** | `req[0]` active (Masks bits 1, 2, and 3) |
| `4'bxx10` | `4 me0010` | **`req[1]`** | `req[1]` active (`req[0]` inactive) |
| `4'bx100` | `4'b0100` | **`req[2]`** | `req[2]` active (`req[0]`, `req[1]` inactive) |
| `4'b1000` | `4'b1000` | **`req[3]`** | `req[3]` active (`req[0]`, `req[1]`, `req[2]` inactive) |

---

### Key Design Characteristics

* **Zero-Latency Combinational Logic:** Operates entirely through pure combinational priority-masking gates, eliminating clock cycle overhead for grant evaluation.
* **One-Hot Encoded Output:** Guarantees that at most one grant signal (`grant[n]`) is asserted at any given time, preventing bus collisions or illegal multi-driver states.
* **Default Idle State:** Automatically drives `grant[3:0] = 4'b0000` when no requestors are active, avoiding false assertions on the shared resource.
* **Starvation Trade-Off:** Optimizes for rapid response time on critical paths (`req[0]`) at the expense of potential starvation on lower-priority channels (`req[3]`) under heavy sustained loads.

---

### Ideal Use Cases
1. **Critical Interrupt Controller Handling:** Routing emergency power, safety, or fault lines that must bypass standard execution queues.
2. **Asymmetric Master Environments:** Shared memory access where a high-bandwidth CPU core requires immediate priority over slower peripheral DMA channels.
