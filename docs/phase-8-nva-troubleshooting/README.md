# Phase 8: NVA Path Troubleshooting (Case Study)

**Status:** Open. Escalated to Microsoft Q&A [add link]. Workaround in use.

## Summary

Traffic from a spoke subnet routed by a user-defined route (UDR) to a Linux NVA in a peered
hub VNet never reaches the NVA. Every configuration check passes, the source VM emits the
packets, and the NVA's NIC sees none of them. The fault sits in the platform path between the
two NICs, or in something not visible from inside either VM. I could not resolve it, so
session-host egress uses a NAT Gateway instead.

## Topology

| Item | Value |
|---|---|
| Hub VNet | vnet-hub-prod-01 (10.200.0.0/16), subnet snet-hub-fw (10.200.1.0/24) |
| NVA | vm-hub-nva-01, Ubuntu 24.04, Standard_B1s, 10.200.1.4, single NIC (eth0) |
| Spoke VNet | vnet-spoke-avd-prod-01 (10.210.0.0/16) |
| Test subnet | snet-test (10.210.2.0/24) with rt-spoke-to-hub attached |
| Test VM | vm-spoke-test, Ubuntu 22.04, 10.210.2.4, no public IP |
| Route | r-default-to-nva: 0.0.0.0/0 -> VirtualAppliance 10.200.1.4 |
| Test target | 20.60.153.129:443 (the AVD DSC download host) |

## Symptom

The AVD session host's DSC extension failed to download its configuration package after 17
attempts ("Unable to connect to the remote server"). A test VM in a subnet with the same UDR
fails the same way:

    curl: (28) Connection timed out after 5002 milliseconds

## What was checked, and what it showed

| # | Layer | Check | Result | Evidence |
|---|---|---|---|---|
| 1 | Route | Effective routes on the spoke NIC | 0.0.0.0/0 -> VirtualAppliance 10.200.1.4, Active; default Internet route Invalid | 01-phase8-effective-routes-spoke-nic |
| 2 | Peering | Both directions | Connected, AllowForwardedTraffic True, AllowVirtualNetworkAccess True | 02-phase8-peering-settings |
| 3 | NSG | Effective security rules on the NVA NIC; Network Watcher IP flow verify (inbound, 10.210.2.4 -> 10.200.1.4:443) | Access allowed, rule AllowVnetInBound. No custom deny | 03-phase8-ipflow-verify-allow |
| 4 | Hub subnet | Route table / NSG on snet-hub-fw | Neither attached | [screenshot] |
| 5 | NIC forwarding | EnableIPForwarding on the NVA NIC | True | 04-phase8-nva-config |
| 6 | NVA OS | ip_forward, iptables, nftables | ip_forward = 1; FORWARD policy ACCEPT; MASQUERADE on eth0; nft chains default accept | 04-phase8-nva-config |
| 7 | NVA egress | curl from the NVA to the target | HTTP 200 | 07-phase8-nva-curl-200 |
| 8 | Reproduction | A second, clean VM in an isolated subnet | Same failure | 05-phase8-sender-tcpdump-syn |
| 9 | Host move | NVA deallocated and started (new host allocation) | Same failure | [note] |

## The decisive observation

Two captures, taken during the same test window on 21 Sep 2026 (about 07:16 UTC):

**Sender (vm-spoke-test, eth0):** five SYN packets to 20.60.153.129:443, one per second,
identical sequence number (TCP retransmission), no reply.

    07:16:38 IP 10.210.2.4.44436 > 20.60.153.129.443: Flags [S], seq 1257109263
    07:16:39 IP 10.210.2.4.44436 > 20.60.153.129.443: Flags [S], seq 1257109263
    ...

**Receiver (vm-hub-nva-01, `tcpdump -nni any 'host 10.210.2.4 or host 20.60.153.129'`):**
zero packets from the spoke subnet.

    0 packets captured

The source emits the packets, and none arrive at the NVA's NIC. Azure's own tooling (effective
routes, IP flow verify) says the flow is deliverable.

## Things that were tried and did not help

- Re-saving and inspecting peerings, NIC forwarding, NSGs (all already correct).
- Deallocating and starting the NVA, which allocates it fresh.
- Testing by IP address rather than hostname, to remove DNS as a variable (the spoke VNet's DNS
  points to the domain controller).

## Limitations of the evidence

- **Network Watcher packet captures returned empty files**, even unfiltered, on a VM that was
  clearly passing traffic. That agent was not producing usable data on this VM, so those files
  are not cited as evidence.
- The two in-guest captures were taken minutes apart in some runs. The paired run above
  (sender and receiver in the same window) is the one to rely on, and it should be repeated with
  both captures started before the test and stopped after it.
- Only one NVA size (B1s) and one region (Central India) were tested.
- A redeploy of the NVA was attempted before the deallocate/start test and was refused
  because the VM was stopped; start-after-deallocate was used instead.

## What I would try next

1. Repeat the paired capture with a filter-free capture on both sides, several attempts per run.
2. Replace the NVA with a fresh VM (different size, ideally with accelerated networking) in the
   same subnet and repeat the test.
3. Test with a two-NIC NVA design (inside and outside interfaces).
4. Compare against Azure Firewall or a route through a VPN gateway, to see whether the fault is
   specific to a single-NIC NVA in a peered hub.
5. If Microsoft Q&A produces a lead, record it here.

## Workaround

- The session-host subnet uses a NAT Gateway for outbound access and has no route table.
- The session host reaches the domain controller through direct spoke-to-on-prem VNet peering
  (added as Phase 2b), bypassing the NVA.
- This works but bypasses the inspection point, so the "NVA as firewall" goal is not met.

## Reference commands

    # effective routes on the spoke NIC
    az network nic show-effective-route-table -g rg-spoke-avd-01 -n <nic> -o table

    # NVA state
    sysctl net.ipv4.ip_forward
    sudo iptables -t nat -S POSTROUTING
    sudo iptables -S FORWARD

    # paired capture: NVA side, then trigger from the spoke
    sudo tcpdump -nni any 'host 10.210.2.4 or host 20.60.153.129'

## Lessons

- A phase can pass its own checklist and still fail the next phase. Phase 2 verified NVA
  configuration but never tested a spoke VM reaching the internet through it.
- A capture that returns zero packets is only evidence if the test ran while it was recording.
  Start captures first, run the test, then stop them.
- Read stderr, not just "Succeeded" in Run Command output.
- Check whether the diagnostic tool itself is working before trusting an empty result.


---
Before you publish it, check these:

Row 4 and row 9 of the table rest on things I saw only as outputs in chat (the empty route table and NSG columns on snet-hub-fw, and the deallocate/start). Add screenshots or drop the evidence column for those rows.

The paired capture is the one I hedged on. The sender's capture was at 07:16:38 to 07:16:42 UTC and your NVA capture ran around 07:17 IST-converted (12:47 IST). Those overlap only if the NVA capture was already running, and the "1 packet received by filter" was never printed. The README says so under Limitations. If you have time before teardown, repeat the run once with both started first, and update the timestamps.

az network nic show-effective-route-table was not a command I ran in this session, so test it before leaving it in the README, or remove that line.

The B1s / Standard_B1s detail comes from your Phase 2 README, and the Ubuntu 22.04 for the test VM from what you deployed. Correct either if they differ.

Blur the subscription ID and any tenant details in the screenshots the README references. Don't commit the .cap files.

For the ticket alternative, the "Summary", "Topology", "What was checked" table and "The decisive observation" sections are the ones to paste into your Microsoft Q&A post, trimmed to the essentials.