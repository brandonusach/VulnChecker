-- ============================================================
--  Tabla: vulnerabilidades
--  Generado: 2026-03-04 16:25:04
--  Total registros: 100
-- ============================================================

CREATE TABLE IF NOT EXISTS vulnerabilidades (
    id                      SERIAL PRIMARY KEY,
    wazuh_doc_id            TEXT,

    -- Agente
    agent_id                TEXT,
    agent_name              TEXT,
    agent_type              TEXT,
    agent_version           TEXT,

    -- Sistema operativo
    os_full                 TEXT,
    os_kernel               TEXT,
    os_name                 TEXT,
    os_platform             TEXT,
    os_version              TEXT,

    -- Paquete afectado
    package_name            TEXT,
    package_version         TEXT,
    package_architecture    TEXT,
    package_type            TEXT,
    package_size            BIGINT,
    package_installed       TIMESTAMPTZ,

    -- Vulnerabilidad
    cve_id                  TEXT,
    severity                TEXT,
    category                TEXT,
    classification          TEXT,
    description             TEXT,
    score_base              NUMERIC(4,1),
    score_version           TEXT,
    enumeration             TEXT,
    published_at            TIMESTAMPTZ,
    detected_at             TIMESTAMPTZ,
    reference               TEXT,
    scanner_vendor          TEXT,
    scanner_source          TEXT,
    under_evaluation        BOOLEAN,

    -- Cluster Wazuh
    wazuh_cluster           TEXT,
    wazuh_schema_version    TEXT,

    created_at              TIMESTAMPTZ DEFAULT NOW()
);


INSERT INTO vulnerabilidades (
    wazuh_doc_id, agent_id, agent_name, agent_type, agent_version,
    os_full, os_kernel, os_name, os_platform, os_version,
    package_name, package_version, package_architecture, package_type, package_size, package_installed,
    cve_id, severity, category, classification, description,
    score_base, score_version, enumeration, published_at, detected_at,
    reference, scanner_vendor, scanner_source, under_evaluation,
    wazuh_cluster, wazuh_schema_version
) VALUES
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2024-53174',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2024-53174', 'High', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

SUNRPC: make sure cache entry active before cache_show

The function `c_show` was called with protection from RCU. This only
ensures that `cp` will not be freed. Therefore, the reference count for
`cp` can drop to zero, which will trigger a refcount use-after-free
warning when `cache_get` is called. To resolve this issue, use
`cache_get_rcu` to ensure that `cp` remains active.

------------[ cut here ]------------
refcount_t: addition on 0; use-after-free.
WARNING: CPU: 7 PID: 822 at lib/refcount.c:25
refcount_warn_saturate+0xb1/0x120
CPU: 7 UID: 0 PID: 822 Comm: cat Not tainted 6.12.0-rc3+ #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.16.1-2.fc37 04/01/2014
RIP: 0010:refcount_warn_saturate+0xb1/0x120

Call Trace:
 <TASK>
 c_show+0x2fc/0x380 [sunrpc]
 seq_read_iter+0x589/0x770
 seq_read+0x1e5/0x270
 proc_reg_read+0xe1/0x140
 vfs_read+0x125/0x530
 ksys_read+0xc1/0x160
 do_syscall_64+0x5f/0x170
 entry_SYSCALL_64_after_hwframe+0x76/0x7e',
    7.1, '3.1', 'CVE', '2024-12-27T14:15:24Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/security/cve/CVE-2024-53174', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-50174',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-50174', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

net: hinic: avoid kernel hung in hinic_get_stats64()

When using hinic device as a bond slave device, and reading device stats
of master bond device, the kernel may hung.

The kernel panic calltrace as follows:
Kernel panic - not syncing: softlockup: hung tasks
Call trace:
  native_queued_spin_lock_slowpath+0x1ec/0x31c
  dev_get_stats+0x60/0xcc
  dev_seq_printf_stats+0x40/0x120
  dev_seq_show+0x1c/0x40
  seq_read_iter+0x3c8/0x4dc
  seq_read+0xe0/0x130
  proc_reg_read+0xa8/0xe0
  vfs_read+0xb0/0x1d4
  ksys_read+0x70/0xfc
  __arm64_sys_read+0x20/0x30
  el0_svc_common+0x88/0x234
  do_el0_svc+0x2c/0x90
  el0_svc+0x1c/0x30
  el0_sync_handler+0xa8/0xb0
  el0_sync+0x148/0x180

And the calltrace of task that actually caused kernel hungs as follows:
  __switch_to+124
  __schedule+548
  schedule+72
  schedule_timeout+348
  __down_common+188
  __down+24
  down+104
  hinic_get_stats64+44 [hinic]
  dev_get_stats+92
  bond_get_stats+172 [bonding]
  dev_get_stats+92
  dev_seq_printf_stats+60
  dev_seq_show+24
  seq_read_iter+964
  seq_read+220
  proc_reg_read+164
  vfs_read+172
  ksys_read+108
  __arm64_sys_read+28
  el0_svc_common+132
  do_el0_svc+40
  el0_svc+24
  el0_sync_handler+164
  el0_sync+324

When getting device stats from bond, kernel will call bond_get_stats().
It first holds the spinlock bond->stats_lock, and then call
hinic_get_stats64() to collect hinic device''s stats.
However, hinic_get_stats64() calls `down(&nic_dev->mgmt_lock)` to
protect its critical section, which may schedule current task out.
And if system is under high pressure, the task cannot be woken up
immediately, which eventually triggers kernel hung panic.

Since previous patch has replaced hinic_dev.tx_stats/rx_stats with local
variable in hinic_get_stats64(), there is nothing need to be protected
by lock, so just removing down()/up() is ok.',
    4.1, '3.1', 'CVE', '2025-06-18T11:15:47Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/security/cve/CVE-2022-50174', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-24448',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-24448', 'Low', 'Packages', '-', 'The kernel packages contain the Linux kernel, the core of any Linux operating system.

Security Fix(es):

* off-path attacker may inject data or terminate victim''s TCP session (CVE-2020-36516)

* race condition in VT_RESIZEX ioctl when vc_cons[i].d is already NULL leading to NULL pointer dereference (CVE-2020-36558)

* use-after-free vulnerability in function sco_sock_sendmsg() (CVE-2021-3640)

* memory leak for large arguments in video_usercopy function in drivers/media/v4l2-core/v4l2-ioctl.c (CVE-2021-30002)

* smb2_ioctl_query_info NULL Pointer Dereference (CVE-2022-0168)

* NULL pointer dereference in udf_expand_file_adinicbdue() during writeback (CVE-2022-0617)

* swiotlb information leak with DMA_FROM_DEVICE (CVE-2022-0854)

* uninitialized registers on stack in nft_do_chain can cause kernel pointer leakage to UM (CVE-2022-1016)

* race condition in snd_pcm_hw_free leading to use-after-free (CVE-2022-1048)

* use-after-free in tc_new_tfilter() in net/sched/cls_api.c (CVE-2022-1055)

* use-after-free and memory errors in ext4 when mounting and operating on a corrupted image (CVE-2022-1184)

* NULL pointer dereference in x86_emulate_insn may lead to DoS (CVE-2022-1852)

* buffer overflow in nft_set_desc_concat_parse() (CVE-2022-2078)

* nf_tables cross-table potential use-after-free may lead to local privilege escalation (CVE-2022-2586)

* openvswitch: integer underflow leads to out-of-bounds write in reserve_sfa_size() (CVE-2022-2639)

* use-after-free when psi trigger is destroyed while being polled (CVE-2022-2938)

* net/packet: slab-out-of-bounds access in packet_recvmsg() (CVE-2022-20368)

* possible to use the debugger to write zero into a location of choice (CVE-2022-21499)

* Spectre-BHB (CVE-2022-23960)

* Post-barrier Return Stack Buffer Predictions (CVE-2022-26373)

* memory leak in drivers/hid/hid-elo.c (CVE-2022-27950)

* double free in ems_usb_start_xmit in drivers/net/can/usb/ems_usb.c (CVE-2022-28390)

* use after free in SUNRPC subsystem (CVE-2022-28893)

* use-after-free due to improper update of reference count in net/sched/cls_u32.c (CVE-2022-29581)

* DoS in nfqnl_mangle in net/netfilter/nfnetlink_queue.c (CVE-2022-36946)

* nfs_atomic_open() returns uninitialized data instead of ENOTDIR (CVE-2022-24448)

For more details about the security issue(s), including the impact, a CVSS score, acknowledgments, and other related information, refer to the CVE page(s) listed in the References section.

Additional Changes:

For detailed information on changes in this release, see the Red Hat Enterprise Linux 8.7 Release Notes linked from the References section.',
    3.3, '3.1', 'CVE', '2022-02-04T20:15:08Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/errata/RHSA-2022:7444, https://access.redhat.com/errata/RHSA-2022:7683, https://access.redhat.com/security/cve/CVE-2022-24448', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2024-44964',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2024-44964', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

idpf: fix memory leaks and crashes while performing a soft reset

The second tagged commit introduced a UAF, as it removed restoring
q_vector->vport pointers after reinitializating the structures.
This is due to that all queue allocation functions are performed here
with the new temporary vport structure and those functions rewrite
the backpointers to the vport. Then, this new struct is freed and
the pointers start leading to nowhere.

But generally speaking, the current logic is very fragile. It claims
to be more reliable when the system is low on memory, but in fact, it
consumes two times more memory as at the moment of running this
function, there are two vports allocated with their queues and vectors.
Moreover, it claims to prevent the driver from running into "bad state",
but in fact, any error during the rebuild leaves the old vport in the
partially allocated state.
Finally, if the interface is down when the function is called, it always
allocates a new queue set, but when the user decides to enable the
interface later on, vport_open() allocates them once again, IOW there''s
a clear memory leak here.

Just don''t allocate a new queue set when performing a reset, that solves
crashes and memory leaks. Readd the old queue number and reopen the
interface on rollback - that solves limbo states when the device is left
disabled and/or without HW queues enabled.',
    6.7, '3.1', 'CVE', '2024-09-04T19:15:30Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/security/cve/CVE-2024-44964', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2021-47413',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2021-47413', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

usb: chipidea: ci_hdrc_imx: Also search for ''phys'' phandle

When passing ''phys'' in the devicetree to describe the USB PHY phandle
(which is the recommended way according to
Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt) the
following NULL pointer dereference is observed on i.MX7 and i.MX8MM:

[    1.489344] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000098
[    1.498170] Mem abort info:
[    1.500966]   ESR = 0x96000044
[    1.504030]   EC = 0x25: DABT (current EL), IL = 32 bits
[    1.509356]   SET = 0, FnV = 0
[    1.512416]   EA = 0, S1PTW = 0
[    1.515569]   FSC = 0x04: level 0 translation fault
[    1.520458] Data abort info:
[    1.523349]   ISV = 0, ISS = 0x00000044
[    1.527196]   CM = 0, WnR = 1
[    1.530176] [0000000000000098] user address but active_mm is swapper
[    1.536544] Internal error: Oops: 96000044 [#1] PREEMPT SMP
[    1.542125] Modules linked in:
[    1.545190] CPU: 3 PID: 7 Comm: kworker/u8:0 Not tainted 5.14.0-dirty #3
[    1.551901] Hardware name: Kontron i.MX8MM N801X S (DT)
[    1.557133] Workqueue: events_unbound deferred_probe_work_func
[    1.562984] pstate: 80000005 (Nzcv daif -PAN -UAO -TCO BTYPE=--)
[    1.568998] pc : imx7d_charger_detection+0x3f0/0x510
[    1.573973] lr : imx7d_charger_detection+0x22c/0x510

This happens because the charger functions check for the phy presence
inside the imx_usbmisc_data structure (data->usb_phy), but the chipidea
core populates the usb_phy passed via ''phys'' inside ''struct ci_hdrc''
(ci->usb_phy) instead.

This causes the NULL pointer dereference inside imx7d_charger_detection().

Fix it by also searching for ''phys'' in case ''fsl,usbphy'' is not found.

Tested on a imx7s-warp board.',
    4.4, '3.1', 'CVE', '2024-05-21T15:15:26Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/security/cve/CVE-2021-47413', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2023-53292',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2023-53292', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

blk-mq: fix NULL dereference on q->elevator in blk_mq_elv_switch_none

After grabbing q->sysfs_lock, q->elevator may become NULL because of
elevator switch.

Fix the NULL dereference on q->elevator by checking it with lock.',
    5.5, '3.1', 'CVE', '2025-09-16T08:15:38Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/security/cve/CVE-2023-53292', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-49985',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-49985', 'High', 'Packages', '-', 'The kernel packages contain the Linux kernel, the core of any Linux operating system.

Security Fix(es):

* kernel: bpf: Don''t use tnum_range on array range checking for poke descriptors (CVE-2022-49985)

* kernel: posix-cpu-timers: fix race between handle_posix_cpu_timers() and posix_cpu_timer_del() (CVE-2025-38352)

For more details about the security issue(s), including the impact, a CVSS score, acknowledgments, and other related information, refer to the CVE page(s) listed in the References section.',
    7.0, '3.1', 'CVE', '2025-06-18T11:15:26Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/errata/RHSA-2025:15471, https://access.redhat.com/errata/RHSA-2025:15472, https://access.redhat.com/security/cve/CVE-2022-49985', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2021-47003',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2021-47003', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

dmaengine: idxd: Fix potential null dereference on pointer status

There are calls to idxd_cmd_exec that pass a null status pointer however
a recent commit has added an assignment to *status that can end up
with a null pointer dereference.  The function expects a null status
pointer sometimes as there is a later assignment to *status where
status is first null checked.  Fix the issue by null checking status
before making the assignment.

Addresses-Coverity: ("Explicit null dereferenced")',
    4.4, '3.1', 'CVE', '2024-02-28T09:15:38Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/security/cve/CVE-2021-47003', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2024-56658',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2024-56658', 'High', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

net: defer final ''struct net'' free in netns dismantle

Ilya reported a slab-use-after-free in dst_destroy [1]

Issue is in xfrm6_net_init() and xfrm4_net_init() :

They copy xfrm[46]_dst_ops_template into net->xfrm.xfrm[46]_dst_ops.

But net structure might be freed before all the dst callbacks are
called. So when dst_destroy() calls later :

if (dst->ops->destroy)
    dst->ops->destroy(dst);

dst->ops points to the old net->xfrm.xfrm[46]_dst_ops, which has been freed.

See a relevant issue fixed in :

ac888d58869b ("net: do not delay dst_entries_add() in dst_release()")

A fix is to queue the ''struct net'' to be freed after one
another cleanup_net() round (and existing rcu_barrier())

[1]

BUG: KASAN: slab-use-after-free in dst_destroy (net/core/dst.c:112)
Read of size 8 at addr ffff8882137ccab0 by task swapper/37/0
Dec 03 05:46:18 kernel:
CPU: 37 UID: 0 PID: 0 Comm: swapper/37 Kdump: loaded Not tainted 6.12.0 #67
Hardware name: Red Hat KVM/RHEL, BIOS 1.16.1-1.el9 04/01/2014
Call Trace:
 <IRQ>
dump_stack_lvl (lib/dump_stack.c:124)
print_address_description.constprop.0 (mm/kasan/report.c:378)
? dst_destroy (net/core/dst.c:112)
print_report (mm/kasan/report.c:489)
? dst_destroy (net/core/dst.c:112)
? kasan_addr_to_slab (mm/kasan/common.c:37)
kasan_report (mm/kasan/report.c:603)
? dst_destroy (net/core/dst.c:112)
? rcu_do_batch (kernel/rcu/tree.c:2567)
dst_destroy (net/core/dst.c:112)
rcu_do_batch (kernel/rcu/tree.c:2567)
? __pfx_rcu_do_batch (kernel/rcu/tree.c:2491)
? lockdep_hardirqs_on_prepare (kernel/locking/lockdep.c:4339 kernel/locking/lockdep.c:4406)
rcu_core (kernel/rcu/tree.c:2825)
handle_softirqs (kernel/softirq.c:554)
__irq_exit_rcu (kernel/softirq.c:589 kernel/softirq.c:428 kernel/softirq.c:637)
irq_exit_rcu (kernel/softirq.c:651)
sysvec_apic_timer_interrupt (arch/x86/kernel/apic/apic.c:1049 arch/x86/kernel/apic/apic.c:1049)
 </IRQ>
 <TASK>
asm_sysvec_apic_timer_interrupt (./arch/x86/include/asm/idtentry.h:702)
RIP: 0010:default_idle (./arch/x86/include/asm/irqflags.h:37 ./arch/x86/include/asm/irqflags.h:92 arch/x86/kernel/process.c:743)
Code: 00 4d 29 c8 4c 01 c7 4c 29 c2 e9 6e ff ff ff 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 66 90 0f 00 2d c7 c9 27 00 fb f4 <fa> c3 cc cc cc cc 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 90
RSP: 0018:ffff888100d2fe00 EFLAGS: 00000246
RAX: 00000000001870ed RBX: 1ffff110201a5fc2 RCX: ffffffffb61a3e46
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffffb3d4d123
RBP: 0000000000000000 R08: 0000000000000001 R09: ffffed11c7e1835d
R10: ffff888e3f0c1aeb R11: 0000000000000000 R12: 0000000000000000
R13: ffff888100d20000 R14: dffffc0000000000 R15: 0000000000000000
? ct_kernel_exit.constprop.0 (kernel/context_tracking.c:148)
? cpuidle_idle_call (kernel/sched/idle.c:186)
default_idle_call (./include/linux/cpuidle.h:143 kernel/sched/idle.c:118)
cpuidle_idle_call (kernel/sched/idle.c:186)
? __pfx_cpuidle_idle_call (kernel/sched/idle.c:168)
? lock_release (kernel/locking/lockdep.c:467 kernel/locking/lockdep.c:5848)
? lockdep_hardirqs_on_prepare (kernel/locking/lockdep.c:4347 kernel/locking/lockdep.c:4406)
? tsc_verify_tsc_adjust (arch/x86/kernel/tsc_sync.c:59)
do_idle (kernel/sched/idle.c:326)
cpu_startup_entry (kernel/sched/idle.c:423 (discriminator 1))
start_secondary (arch/x86/kernel/smpboot.c:202 arch/x86/kernel/smpboot.c:282)
? __pfx_start_secondary (arch/x86/kernel/smpboot.c:232)
? soft_restart_cpu (arch/x86/kernel/head_64.S:452)
common_startup_64 (arch/x86/kernel/head_64.S:414)
 </TASK>
Dec 03 05:46:18 kernel:
Allocated by task 12184:
kasan_save_stack (mm/kasan/common.c:48)
kasan_save_track (./arch/x86/include/asm/current.h:49 mm/kasan/common.c:60 mm/kasan/common.c:69)
__kasan_slab_alloc (mm/kasan/common.c:319 mm/kasan/common.c:345)
kmem_cache_alloc_noprof (mm/slub.c:4085 mm/slub.c:4134 mm/slub.c:4141)
copy_net_ns (net/core/net_namespace.c:421 net/core/net_namespace.c:480)
create_new_namespaces
---truncated--- 
            This issue is considered to be a moderat...',
    7.1, '3.1', 'CVE', '2024-12-27T15:15:25Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/security/cve/CVE-2024-56658', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-42722',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-42722', 'Medium', 'Packages', '-', 'The kernel packages contain the Linux kernel, the core of any Linux operating system.

The following packages have been upgraded to a later upstream version: kernel (4.18.0). (BZ#2122230, BZ#2122267)

Security Fix(es):

* use-after-free caused by l2cap_reassemble_sdu() in net/bluetooth/l2cap_core.c (CVE-2022-3564)

* net/ulp: use-after-free in listening ULP sockets (CVE-2023-0461)

* hw: cpu: AMD CPUs may transiently execute beyond unconditional direct branch (CVE-2021-26341)

* malicious data for FBIOPUT_VSCREENINFO ioctl may cause OOB write memory (CVE-2021-33655)

* when setting font with malicious data by ioctl PIO_FONT, kernel will write memory out of bounds (CVE-2021-33656)

* possible race condition in drivers/tty/tty_buffers.c (CVE-2022-1462)

* use-after-free in ath9k_htc_probe_device() could cause an escalation of privileges (CVE-2022-1679)

* KVM: NULL pointer dereference in kvm_mmu_invpcid_gva (CVE-2022-1789)

* KVM: nVMX: missing IBPB when exiting from nested guest can lead to Spectre v2 attacks (CVE-2022-2196)

* netfilter: nf_conntrack_irc message handling issue (CVE-2022-2663)

* race condition in xfrm_probe_algs can lead to OOB read/write (CVE-2022-3028)

* media: em28xx: initialize refcount before kref_get (CVE-2022-3239)

* race condition in hugetlb_no_page() in mm/hugetlb.c (CVE-2022-3522)

* memory leak in ipv6_renew_options() (CVE-2022-3524)

* data races around icsk->icsk_af_ops in do_ipv6_setsockopt (CVE-2022-3566)

* data races around sk->sk_prot (CVE-2022-3567)

* memory leak in l2cap_recv_acldata of the file net/bluetooth/l2cap_core.c (CVE-2022-3619)

* denial of service in follow_page_pte in mm/gup.c due to poisoned pte entry (CVE-2022-3623)

* use-after-free after failed devlink reload in devlink_param_get (CVE-2022-3625)

* USB-accessible buffer overflow in brcmfmac (CVE-2022-3628)

* Double-free in split_2MB_gtt_entry when function intel_gvt_dma_map_guest_page failed (CVE-2022-3707)

* l2tp: missing lock when clearing sk_user_data can lead to NULL pointer dereference (CVE-2022-4129)

* igmp: use-after-free in ip_check_mc_rcu when opening and closing inet sockets (CVE-2022-20141)

* Executable Space Protection Bypass (CVE-2022-25265)

* Unprivileged users may use PTRACE_SEIZE to set PTRACE_O_SUSPEND_SECCOMP option (CVE-2022-30594)

* unmap_mapping_range() race with munmap() on VM_PFNMAP mappings leads to stale TLB entry (CVE-2022-39188)

* TLB flush operations are mishandled in certain KVM_VCPU_PREEMPTED leading to guest malfunctioning (CVE-2022-39189)

* Report vmalloc UAF in dvb-core/dmxdev (CVE-2022-41218)

* u8 overflow problem in cfg80211_update_notlisted_nontrans() (CVE-2022-41674)

* use-after-free related to leaf anon_vma double reuse (CVE-2022-42703)

* use-after-free in bss_ref_get in net/wireless/scan.c (CVE-2022-42720)

* BSS list corruption in cfg80211_add_nontrans_list in net/wireless/scan.c (CVE-2022-42721)

* Denial of service in beacon protection for P2P-device (CVE-2022-42722)

* memory corruption in usbmon driver (CVE-2022-43750)

* NULL pointer dereference in traffic control subsystem (CVE-2022-47929)

* NULL pointer dereference in rawv6_push_pending_frames (CVE-2023-0394)

* use-after-free caused by invalid pointer hostname in fs/cifs/connect.c (CVE-2023-1195)

* Soft lockup occurred during __page_mapcount (CVE-2023-1582)

* slab-out-of-bounds read vulnerabilities in cbq_classify (CVE-2023-23454)

For more details about the security issue(s), including the impact, a CVSS score, acknowledgments, and other related information, refer to the CVE page(s) listed in the References section.

Additional Changes:

For detailed information on changes in this release, see the Red Hat Enterprise Linux 8.8 Release Notes linked from the References section.',
    5.5, '3.1', 'CVE', '2022-10-14T00:15:09Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/errata/RHSA-2023:2736, https://access.redhat.com/errata/RHSA-2023:2951, https://access.redhat.com/security/cve/CVE-2022-42722', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-42895',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-42895', 'Medium', 'Packages', '-', 'The kernel packages contain the Linux kernel, the core of any Linux operating system.

Security Fix(es):

* kernel: tun: avoid double free in tun_free_netdev (CVE-2022-4744)

* kernel: net/sched: multiple vulnerabilities (CVE-2023-3609, CVE-2023-3611, CVE-2023-4128, CVE-2023-4206, CVE-2023-4207, CVE-2023-4208)

* kernel: out-of-bounds write in qfq_change_class function (CVE-2023-31436)

* kernel: out-of-bounds write in hw_atl_utils_fw_rpc_wait (CVE-2021-43975)

* kernel: Rate limit overflow messages in r8152 in intr_callback (CVE-2022-3594)

* kernel: use after free flaw in l2cap_conn_del (CVE-2022-3640)

* kernel: double free in usb_8dev_start_xmit (CVE-2022-28388)

* kernel: vmwgfx: multiple vulnerabilities (CVE-2022-38457, CVE-2022-40133, CVE-2023-33951, CVE-2023-33952)

* hw: Intel: Gather Data Sampling (GDS) side channel vulnerability (CVE-2022-40982)

* kernel: Information leak in l2cap_parse_conf_req (CVE-2022-42895)

* kernel: KVM: multiple vulnerabilities (CVE-2022-45869, CVE-2023-4155, CVE-2023-30456)

* kernel: memory leak in ttusb_dec_exit_dvb (CVE-2022-45887)

* kernel: speculative pointer dereference in do_prlimit (CVE-2023-0458)

* kernel: use-after-free due to race condition in qdisc_graft (CVE-2023-0590)

* kernel: x86/mm: Randomize per-cpu entry area (CVE-2023-0597)

* kernel: HID: check empty report_list in hid_validate_values (CVE-2023-1073)

* kernel: sctp: fail if no bound addresses can be used for a given scope (CVE-2023-1074)

* kernel: hid: Use After Free in asus_remove (CVE-2023-1079)

* kernel: use-after-free in drivers/media/rc/ene_ir.c (CVE-2023-1118)

* kernel: hash collisions in the IPv6 connection lookup table (CVE-2023-1206)

* kernel: ovl: fix use after free in struct ovl_aio_req (CVE-2023-1252)

* kernel: denial of service in tipc_conn_close (CVE-2023-1382)

* kernel: Use after free bug in btsdio_remove due to race condition (CVE-2023-1989)

* kernel: Spectre v2 SMT mitigations problem (CVE-2023-1998)

* kernel: ext4: use-after-free in ext4_xattr_set_entry (CVE-2023-2513)

* kernel: fbcon: shift-out-of-bounds in fbcon_set_font (CVE-2023-3161)

* kernel: out-of-bounds access in relay_file_read (CVE-2023-3268)

* kernel: xfrm: NULL pointer dereference in xfrm_update_ae_params (CVE-2023-3772)

* kernel: smsusb: use-after-free caused by do_submit_urb (CVE-2023-4132)

* kernel: Race between task migrating pages and another task calling exit_mmap (CVE-2023-4732)

* Kernel: denial of service in atm_tc_enqueue due to type confusion (CVE-2023-23455)

* kernel: mpls: double free on sysctl allocation failure (CVE-2023-26545)

* kernel: Denial of service issue in az6027 driver (CVE-2023-28328)

* kernel: lib/seq_buf.c has a seq_buf_putmem_hex buffer overflow (CVE-2023-28772)

* kernel: blocking operation in dvb_frontend_get_event and wait_event_interruptible (CVE-2023-31084)

* kernel: net: qcom/emac: race condition leading to use-after-free in emac_remove (CVE-2023-33203)

* kernel: saa7134: race condition leading to use-after-free in saa7134_finidev (CVE-2023-35823)

* kernel: dm1105: race condition leading to use-after-free in dm1105_remove.c (CVE-2023-35824)

* kernel: r592: race condition leading to use-after-free in r592_remove (CVE-2023-35825)

* kernel: net/tls: tls_is_tx_ready() checked list_entry (CVE-2023-1075)

* kernel: use-after-free bug in remove function xgene_hwmon_remove (CVE-2023-1855)

* kernel: Use after free bug in r592_remove (CVE-2023-3141)

* kernel: gfs2: NULL pointer dereference in gfs2_evict_inode (CVE-2023-3212)

For more details about the security issue(s), including the impact, a CVSS score, acknowledgments, and other related information, refer to the CVE page(s) listed in the References section.

Additional Changes:

For detailed information on changes in this release, see the Red Hat Enterprise Linux 8.9 Release Notes linked from the References section.',
    6.5, '3.1', 'CVE', '2022-11-23T15:15:10Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/errata/RHSA-2023:6901, https://access.redhat.com/errata/RHSA-2023:7077, https://access.redhat.com/security/cve/CVE-2022-42895', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2021-47404',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2021-47404', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

HID: betop: fix slab-out-of-bounds Write in betop_probe

Syzbot reported slab-out-of-bounds Write bug in hid-betopff driver.
The problem is the driver assumes the device must have an input report but
some malicious devices violate this assumption.

So this patch checks hid_device''s input is non empty before it''s been used.',
    5.5, '3.1', 'CVE', '2024-05-21T15:15:25Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/security/cve/CVE-2021-47404', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-49673',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-49673', 'Low', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

dm raid: fix KASAN warning in raid5_add_disks

There''s a KASAN warning in raid5_add_disk when running the LVM testsuite.
The warning happens in the test
lvconvert-raid-reshape-linear_to_raid6-single-type.sh. We fix the warning
by verifying that rdev->saved_raid_disk is within limits.',
    3.3, '3.1', 'CVE', '2025-02-26T07:01:42Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/errata/RHSA-2022:7683, https://access.redhat.com/security/cve/CVE-2022-49673', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-50882',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-50882', 'Medium', 'Packages', '-', 'No description is available for this CVE.',
    5.5, '3.1', 'CVE', '2000-01-01T00:00:00Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/security/cve/CVE-2022-50882', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-49308',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-49308', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

extcon: Modify extcon device to be created after driver data is set

Currently, someone can invoke the sysfs such as state_show()
intermittently before dev_set_drvdata() is done.
And it can be a cause of kernel Oops because of edev is Null at that time.
So modified the driver registration to after setting drviver data.

- Oops''s backtrace.

Backtrace:
[<c067865c>] (state_show) from [<c05222e8>] (dev_attr_show)
[<c05222c0>] (dev_attr_show) from [<c02c66e0>] (sysfs_kf_seq_show)
[<c02c6648>] (sysfs_kf_seq_show) from [<c02c496c>] (kernfs_seq_show)
[<c02c4938>] (kernfs_seq_show) from [<c025e2a0>] (seq_read)
[<c025e11c>] (seq_read) from [<c02c50a0>] (kernfs_fop_read)
[<c02c5064>] (kernfs_fop_read) from [<c0231cac>] (__vfs_read)
[<c0231c5c>] (__vfs_read) from [<c0231ee0>] (vfs_read)
[<c0231e34>] (vfs_read) from [<c0232464>] (ksys_read)
[<c02323f0>] (ksys_read) from [<c02324fc>] (sys_read)
[<c02324e4>] (sys_read) from [<c00091d0>] (__sys_trace_return)',
    4.7, '3.1', 'CVE', '2025-02-26T07:01:07Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/security/cve/CVE-2022-49308', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2021-47420',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2021-47420', 'Low', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

drm/amdkfd: fix a potential ttm->sg memory leak

Memory is allocated for ttm->sg by kmalloc in kfd_mem_dmamap_userptr,
but isn''t freed by kfree in kfd_mem_dmaunmap_userptr. Free it!',
    2.3, '3.1', 'CVE', '2024-05-21T15:15:27Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/security/cve/CVE-2021-47420', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-48990',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-48990', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

drm/amdgpu: fix use-after-free during gpu recovery

[Why]
    [  754.862560] refcount_t: underflow; use-after-free.
    [  754.862898] Call Trace:
    [  754.862903]  <TASK>
    [  754.862913]  amdgpu_job_free_cb+0xc2/0xe1 [amdgpu]
    [  754.863543]  drm_sched_main.cold+0x34/0x39 [amd_sched]

[How]
    The fw_fence may be not init, check whether dma_fence_init
    is performed before job free 
            This issue is considered to be a moderate impact flaw, as the exploitation for this will need an ADMIN (or ROOT) privilege (PR:H).',
    6.7, '3.1', 'CVE', '2024-10-21T20:15:10Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/security/cve/CVE-2022-48990', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2025-39883',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2025-39883', 'High', 'Packages', '-', 'The kernel packages contain the Linux kernel, the core of any Linux operating system.

Security Fix(es):

* kernel: nfsd: handle get_client_locked() failure in nfsd4_setclientid_confirm() (CVE-2025-38724)

* kernel: smb: client: fix race with concurrent opens in rename(2) (CVE-2025-39825)

* kernel: mm/memory-failure: fix VM_BUG_ON_PAGE(PagePoisoned(page)) when unpoison memory (CVE-2025-39883)

* kernel: e1000e: fix heap overflow in e1000_set_eeprom (CVE-2025-39898)

* kernel: nbd: fix incomplete validation of ioctl arg (CVE-2023-53513)

* kernel: tcp: Clear tcp_sk(sk)->fastopen_rsk in tcp_disconnect() (CVE-2025-39955)

For more details about the security issue(s), including the impact, a CVSS score, acknowledgments, and other related information, refer to the CVE page(s) listed in the References section.',
    7.0, '3.1', 'CVE', '2000-01-01T00:00:00Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/errata/RHSA-2025:22387, https://access.redhat.com/errata/RHSA-2025:22388, https://access.redhat.com/security/cve/CVE-2025-39883', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2024-57977',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2024-57977', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

memcg: fix soft lockup in the OOM process

A soft lockup issue was found in the product with about 56,000 tasks were
in the OOM cgroup, it was traversing them when the soft lockup was
triggered.

watchdog: BUG: soft lockup - CPU#2 stuck for 23s! [VM Thread:1503066]
CPU: 2 PID: 1503066 Comm: VM Thread Kdump: loaded Tainted: G
Hardware name: Huawei Cloud OpenStack Nova, BIOS
RIP: 0010:console_unlock+0x343/0x540
RSP: 0000:ffffb751447db9a0 EFLAGS: 00000247 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000001 RBX: 0000000000000000 RCX: 00000000ffffffff
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000247
RBP: ffffffffafc71f90 R08: 0000000000000000 R09: 0000000000000040
R10: 0000000000000080 R11: 0000000000000000 R12: ffffffffafc74bd0
R13: ffffffffaf60a220 R14: 0000000000000247 R15: 0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2fe6ad91f0 CR3: 00000004b2076003 CR4: 0000000000360ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 vprintk_emit+0x193/0x280
 printk+0x52/0x6e
 dump_task+0x114/0x130
 mem_cgroup_scan_tasks+0x76/0x100
 dump_header+0x1fe/0x210
 oom_kill_process+0xd1/0x100
 out_of_memory+0x125/0x570
 mem_cgroup_out_of_memory+0xb5/0xd0
 try_charge+0x720/0x770
 mem_cgroup_try_charge+0x86/0x180
 mem_cgroup_try_charge_delay+0x1c/0x40
 do_anonymous_page+0xb5/0x390
 handle_mm_fault+0xc4/0x1f0

This is because thousands of processes are in the OOM cgroup, it takes a
long time to traverse all of them.  As a result, this lead to soft lockup
in the OOM process.

To fix this issue, call ''cond_resched'' in the ''mem_cgroup_scan_tasks''
function per 1000 iterations.  For global OOM, call
''touch_softlockup_watchdog'' per 1000 iterations to avoid this issue.',
    5.5, '3.1', 'CVE', '2025-02-27T02:15:10Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/security/cve/CVE-2024-57977', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-49416',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-49416', 'High', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

wifi: mac80211: fix use-after-free in chanctx code

In ieee80211_vif_use_reserved_context(), when we have an
old context and the new context''s replace_state is set to
IEEE80211_CHANCTX_REPLACE_NONE, we free the old context
in ieee80211_vif_use_reserved_reassign(). Therefore, we
cannot check the old_ctx anymore, so we should set it to
NULL after this point.

However, since the new_ctx replace state is clearly not
IEEE80211_CHANCTX_REPLACES_OTHER, we''re not going to do
anything else in this function and can just return to
avoid accessing the freed old_ctx.',
    7.1, '3.1', 'CVE', '2025-02-26T07:01:18Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/errata/RHSA-2023:2951, https://access.redhat.com/security/cve/CVE-2022-49416', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-43750',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-43750', 'Medium', 'Packages', '-', 'The kernel packages contain the Linux kernel, the core of any Linux operating system.

The following packages have been upgraded to a later upstream version: kernel (4.18.0). (BZ#2122230, BZ#2122267)

Security Fix(es):

* use-after-free caused by l2cap_reassemble_sdu() in net/bluetooth/l2cap_core.c (CVE-2022-3564)

* net/ulp: use-after-free in listening ULP sockets (CVE-2023-0461)

* hw: cpu: AMD CPUs may transiently execute beyond unconditional direct branch (CVE-2021-26341)

* malicious data for FBIOPUT_VSCREENINFO ioctl may cause OOB write memory (CVE-2021-33655)

* when setting font with malicious data by ioctl PIO_FONT, kernel will write memory out of bounds (CVE-2021-33656)

* possible race condition in drivers/tty/tty_buffers.c (CVE-2022-1462)

* use-after-free in ath9k_htc_probe_device() could cause an escalation of privileges (CVE-2022-1679)

* KVM: NULL pointer dereference in kvm_mmu_invpcid_gva (CVE-2022-1789)

* KVM: nVMX: missing IBPB when exiting from nested guest can lead to Spectre v2 attacks (CVE-2022-2196)

* netfilter: nf_conntrack_irc message handling issue (CVE-2022-2663)

* race condition in xfrm_probe_algs can lead to OOB read/write (CVE-2022-3028)

* media: em28xx: initialize refcount before kref_get (CVE-2022-3239)

* race condition in hugetlb_no_page() in mm/hugetlb.c (CVE-2022-3522)

* memory leak in ipv6_renew_options() (CVE-2022-3524)

* data races around icsk->icsk_af_ops in do_ipv6_setsockopt (CVE-2022-3566)

* data races around sk->sk_prot (CVE-2022-3567)

* memory leak in l2cap_recv_acldata of the file net/bluetooth/l2cap_core.c (CVE-2022-3619)

* denial of service in follow_page_pte in mm/gup.c due to poisoned pte entry (CVE-2022-3623)

* use-after-free after failed devlink reload in devlink_param_get (CVE-2022-3625)

* USB-accessible buffer overflow in brcmfmac (CVE-2022-3628)

* Double-free in split_2MB_gtt_entry when function intel_gvt_dma_map_guest_page failed (CVE-2022-3707)

* l2tp: missing lock when clearing sk_user_data can lead to NULL pointer dereference (CVE-2022-4129)

* igmp: use-after-free in ip_check_mc_rcu when opening and closing inet sockets (CVE-2022-20141)

* Executable Space Protection Bypass (CVE-2022-25265)

* Unprivileged users may use PTRACE_SEIZE to set PTRACE_O_SUSPEND_SECCOMP option (CVE-2022-30594)

* unmap_mapping_range() race with munmap() on VM_PFNMAP mappings leads to stale TLB entry (CVE-2022-39188)

* TLB flush operations are mishandled in certain KVM_VCPU_PREEMPTED leading to guest malfunctioning (CVE-2022-39189)

* Report vmalloc UAF in dvb-core/dmxdev (CVE-2022-41218)

* u8 overflow problem in cfg80211_update_notlisted_nontrans() (CVE-2022-41674)

* use-after-free related to leaf anon_vma double reuse (CVE-2022-42703)

* use-after-free in bss_ref_get in net/wireless/scan.c (CVE-2022-42720)

* BSS list corruption in cfg80211_add_nontrans_list in net/wireless/scan.c (CVE-2022-42721)

* Denial of service in beacon protection for P2P-device (CVE-2022-42722)

* memory corruption in usbmon driver (CVE-2022-43750)

* NULL pointer dereference in traffic control subsystem (CVE-2022-47929)

* NULL pointer dereference in rawv6_push_pending_frames (CVE-2023-0394)

* use-after-free caused by invalid pointer hostname in fs/cifs/connect.c (CVE-2023-1195)

* Soft lockup occurred during __page_mapcount (CVE-2023-1582)

* slab-out-of-bounds read vulnerabilities in cbq_classify (CVE-2023-23454)

For more details about the security issue(s), including the impact, a CVSS score, acknowledgments, and other related information, refer to the CVE page(s) listed in the References section.

Additional Changes:

For detailed information on changes in this release, see the Red Hat Enterprise Linux 8.8 Release Notes linked from the References section.',
    6.7, '3.1', 'CVE', '2022-10-26T04:15:13Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/errata/RHSA-2023:2736, https://access.redhat.com/errata/RHSA-2023:2951, https://access.redhat.com/security/cve/CVE-2022-43750', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2024-56688',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2024-56688', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

sunrpc: clear XPRT_SOCK_UPD_TIMEOUT when reset transport

Since transport->sock has been set to NULL during reset transport,
XPRT_SOCK_UPD_TIMEOUT also needs to be cleared. Otherwise, the
xs_tcp_set_socket_timeouts() may be triggered in xs_tcp_send_request()
to dereference the transport->sock that has been set to NULL.',
    5.5, '3.1', 'CVE', '2024-12-28T10:15:12Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/security/cve/CVE-2024-56688', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2021-47615',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2021-47615', 'Medium', 'Packages', '-', '[REJECTED CVE] In the Linux kernel, the following vulnerability has been resolved:
RDMA/mlx5: Fix releasing unallocated memory in dereg MR flow 
            This CVE has been rejected by the Linux kernel community. Refer to the announcement: https://lore.kernel.org/linux-cve-announce/2024121907-REJECTED-b9ce@gregkh/',
    4.4, '3.1', 'CVE', '2024-06-19T15:15:56Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/security/cve/CVE-2021-47615', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2025-39746',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2025-39746', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

wifi: ath10k: shutdown driver when hardware is unreliable

In rare cases, ath10k may lose connection with the PCIe bus due to
some unknown reasons, which could further lead to system crashes during
resuming due to watchdog timeout:

ath10k_pci 0000:01:00.0: wmi command 20486 timeout, restarting hardware
ath10k_pci 0000:01:00.0: already restarting
ath10k_pci 0000:01:00.0: failed to stop WMI vdev 0: -11
ath10k_pci 0000:01:00.0: failed to stop vdev 0: -11
ieee80211 phy0: PM: **** DPM device timeout ****
Call Trace:
 panic+0x125/0x315
 dpm_watchdog_set+0x54/0x54
 dpm_watchdog_handler+0x57/0x57
 call_timer_fn+0x31/0x13c

At this point, all WMI commands will timeout and attempt to restart
device. So set a threshold for consecutive restart failures. If the
threshold is exceeded, consider the hardware is unreliable and all
ath10k operations should be skipped to avoid system crash.

fail_cont_count and pending_recovery are atomic variables, and
do not involve complex conditional logic. Therefore, even if recovery
check and reconfig complete are executed concurrently, the recovery
mechanism will not be broken.

Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00288-QCARMSWPZ-1',
    4.4, '3.1', 'CVE', '2025-09-11T17:15:37Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/security/cve/CVE-2025-39746', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-49287',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-49287', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

tpm: fix reference counting for struct tpm_chip

The following sequence of operations results in a refcount warning:

1. Open device /dev/tpmrm.
2. Remove module tpm_tis_spi.
3. Write a TPM command to the file descriptor opened at step 1.

------------[ cut here ]------------
WARNING: CPU: 3 PID: 1161 at lib/refcount.c:25 kobject_get+0xa0/0xa4
refcount_t: addition on 0; use-after-free.
Modules linked in: tpm_tis_spi tpm_tis_core tpm mdio_bcm_unimac brcmfmac
sha256_generic libsha256 sha256_arm hci_uart btbcm bluetooth cfg80211 vc4
brcmutil ecdh_generic ecc snd_soc_core crc32_arm_ce libaes
raspberrypi_hwmon ac97_bus snd_pcm_dmaengine bcm2711_thermal snd_pcm
snd_timer genet snd phy_generic soundcore [last unloaded: spi_bcm2835]
CPU: 3 PID: 1161 Comm: hold_open Not tainted 5.10.0ls-main-dirty #2
Hardware name: BCM2711
[<c0410c3c>] (unwind_backtrace) from [<c040b580>] (show_stack+0x10/0x14)
[<c040b580>] (show_stack) from [<c1092174>] (dump_stack+0xc4/0xd8)
[<c1092174>] (dump_stack) from [<c0445a30>] (__warn+0x104/0x108)
[<c0445a30>] (__warn) from [<c0445aa8>] (warn_slowpath_fmt+0x74/0xb8)
[<c0445aa8>] (warn_slowpath_fmt) from [<c08435d0>] (kobject_get+0xa0/0xa4)
[<c08435d0>] (kobject_get) from [<bf0a715c>] (tpm_try_get_ops+0x14/0x54 [tpm])
[<bf0a715c>] (tpm_try_get_ops [tpm]) from [<bf0a7d6c>] (tpm_common_write+0x38/0x60 [tpm])
[<bf0a7d6c>] (tpm_common_write [tpm]) from [<c05a7ac0>] (vfs_write+0xc4/0x3c0)
[<c05a7ac0>] (vfs_write) from [<c05a7ee4>] (ksys_write+0x58/0xcc)
[<c05a7ee4>] (ksys_write) from [<c04001a0>] (ret_fast_syscall+0x0/0x4c)
Exception stack(0xc226bfa8 to 0xc226bff0)
bfa0:                   00000000 000105b4 00000003 beafe664 00000014 00000000
bfc0: 00000000 000105b4 000103f8 00000004 00000000 00000000 b6f9c000 beafe684
bfe0: 0000006c beafe648 0001056c b6eb6944
---[ end trace d4b8409def9b8b1f ]---

The reason for this warning is the attempt to get the chip->dev reference
in tpm_common_write() although the reference counter is already zero.

Since commit 8979b02aaf1d ("tpm: Fix reference count to main device") the
extra reference used to prevent a premature zero counter is never taken,
because the required TPM_CHIP_FLAG_TPM2 flag is never set.

Fix this by moving the TPM 2 character device handling from
tpm_chip_alloc() to tpm_add_char_device() which is called at a later point
in time when the flag has been set in case of TPM2.

Commit fdc915f7f719 ("tpm: expose spaces via a device link /dev/tpmrm<n>")
already introduced function tpm_devs_release() to release the extra
reference but did not implement the required put on chip->devs that results
in the call of this function.

Fix this by putting chip->devs in tpm_chip_unregister().

Finally move the new implementation for the TPM 2 handling into a new
function to avoid multiple checks for the TPM_CHIP_FLAG_TPM2 flag in the
good case and error cases.',
    5.5, '3.1', 'CVE', '2025-02-26T07:01:05Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/security/cve/CVE-2022-49287', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2024-43834',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2024-43834', 'Medium', 'Packages', '-', 'The MITRE CVE dictionary describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

xdp: fix invalid wait context of page_pool_destroy()

If the driver uses a page pool, it creates a page pool with
page_pool_create().
The reference count of page pool is 1 as default.
A page pool will be destroyed only when a reference count reaches 0.
page_pool_destroy() is used to destroy page pool, it decreases a
reference count.
When a page pool is destroyed, ->disconnect() is called, which is
mem_allocator_disconnect().
This function internally acquires mutex_lock().

If the driver uses XDP, it registers a memory model with
xdp_rxq_info_reg_mem_model().
The xdp_rxq_info_reg_mem_model() internally increases a page pool
reference count if a memory model is a page pool.
Now the reference count is 2.

To destroy a page pool, the driver should call both page_pool_destroy()
and xdp_unreg_mem_model().
The xdp_unreg_mem_model() internally calls page_pool_destroy().
Only page_pool_destroy() decreases a reference count.

If a driver calls page_pool_destroy() then xdp_unreg_mem_model(), we
will face an invalid wait context warning.
Because xdp_unreg_mem_model() calls page_pool_destroy() with
rcu_read_lock().
The page_pool_destroy() internally acquires mutex_lock().

Splat looks like:
=============================
[ BUG: Invalid wait context ]
6.10.0-rc6+ #4 Tainted: G W
-----------------------------
ethtool/1806 is trying to lock:
ffffffff90387b90 (mem_id_lock){+.+.}-{4:4}, at: mem_allocator_disconnect+0x73/0x150
other info that might help us debug this:
context-{5:5}
3 locks held by ethtool/1806:
stack backtrace:
CPU: 0 PID: 1806 Comm: ethtool Tainted: G W 6.10.0-rc6+ #4 f916f41f172891c800f2fed
Hardware name: ASUS System Product Name/PRIME Z690-P D4, BIOS 0603 11/01/2021
Call Trace:
<TASK>
dump_stack_lvl+0x7e/0xc0
__lock_acquire+0x1681/0x4de0
? _printk+0x64/0xe0
? __pfx_mark_lock.part.0+0x10/0x10
? __pfx___lock_acquire+0x10/0x10
lock_acquire+0x1b3/0x580
? mem_allocator_disconnect+0x73/0x150
? __wake_up_klogd.part.0+0x16/0xc0
? __pfx_lock_acquire+0x10/0x10
? dump_stack_lvl+0x91/0xc0
__mutex_lock+0x15c/0x1690
? mem_allocator_disconnect+0x73/0x150
? __pfx_prb_read_valid+0x10/0x10
? mem_allocator_disconnect+0x73/0x150
? __pfx_llist_add_batch+0x10/0x10
? console_unlock+0x193/0x1b0
? lockdep_hardirqs_on+0xbe/0x140
? __pfx___mutex_lock+0x10/0x10
? tick_nohz_tick_stopped+0x16/0x90
? __irq_work_queue_local+0x1e5/0x330
? irq_work_queue+0x39/0x50
? __wake_up_klogd.part.0+0x79/0xc0
? mem_allocator_disconnect+0x73/0x150
mem_allocator_disconnect+0x73/0x150
? __pfx_mem_allocator_disconnect+0x10/0x10
? mark_held_locks+0xa5/0xf0
? rcu_is_watching+0x11/0xb0
page_pool_release+0x36e/0x6d0
page_pool_destroy+0xd7/0x440
xdp_unreg_mem_model+0x1a7/0x2a0
? __pfx_xdp_unreg_mem_model+0x10/0x10
? kfree+0x125/0x370
? bnxt_free_ring.isra.0+0x2eb/0x500
? bnxt_free_mem+0x5ac/0x2500
xdp_rxq_info_unreg+0x4a/0xd0
bnxt_free_mem+0x1356/0x2500
bnxt_close_nic+0xf0/0x3b0
? __pfx_bnxt_close_nic+0x10/0x10
? ethnl_parse_bit+0x2c6/0x6d0
? __pfx___nla_validate_parse+0x10/0x10
? __pfx_ethnl_parse_bit+0x10/0x10
bnxt_set_features+0x2a8/0x3e0
__netdev_update_features+0x4dc/0x1370
? ethnl_parse_bitset+0x4ff/0x750
? __pfx_ethnl_parse_bitset+0x10/0x10
? __pfx___netdev_update_features+0x10/0x10
? mark_held_locks+0xa5/0xf0
? _raw_spin_unlock_irqrestore+0x42/0x70
? __pm_runtime_resume+0x7d/0x110
ethnl_set_features+0x32d/0xa20

To fix this problem, it uses rhashtable_lookup_fast() instead of
rhashtable_lookup() with rcu_read_lock().
Using xa without rcu_read_lock() here is safe.
xa is freed by __xdp_mem_allocator_rcu_free() and this is called by
call_rcu() of mem_xa_remove().
The mem_xa_remove() is called by page_pool_destroy() if a reference
count reaches 0.
The xa is already protected by the reference count mechanism well in the
control plane.
So removing rcu_read_lock() for page_pool_destroy() is safe.',
    5.5, '3.1', 'CVE', '2024-08-17T10:15:09Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/security/cve/CVE-2024-43834', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2021-45485',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2021-45485', 'High', 'Packages', '-', 'The kernel packages contain the Linux kernel, the core of any Linux operating system.

Security Fix(es):

* kernel: fget: check that the fd still exists after getting a ref to it (CVE-2021-4083)

* kernel: avoid cyclic entity chains due to malformed USB descriptors (CVE-2020-0404)

* kernel: speculation on incompletely validated data on IBM Power9 (CVE-2020-4788)

* kernel: integer overflow in k_ascii() in drivers/tty/vt/keyboard.c (CVE-2020-13974)

* kernel: out-of-bounds read in bpf_skb_change_head() of filter.c due to a use-after-free (CVE-2021-0941)

* kernel: joydev: zero size passed to joydev_handle_JSIOCSBTNMAP() (CVE-2021-3612)

* kernel: reading /proc/sysvipc/shm does not scale with large shared memory segment counts (CVE-2021-3669)

* kernel: out-of-bound Read in qrtr_endpoint_post in net/qrtr/qrtr.c (CVE-2021-3743)

* kernel: crypto: ccp - fix resource leaks in ccp_run_aes_gcm_cmd() (CVE-2021-3744)

* kernel: possible use-after-free in bluetooth module (CVE-2021-3752)

* kernel: unaccounted ipc objects in Linux kernel lead to breaking memcg limits and DoS attacks (CVE-2021-3759)

* kernel: DoS in ccp_run_aes_gcm_cmd() function (CVE-2021-3764)

* kernel: sctp: Invalid chunks may be used to remotely remove existing associations (CVE-2021-3772)

* kernel: lack of port sanity checking in natd and netfilter leads to exploit of OpenVPN clients (CVE-2021-3773)

* kernel: possible leak or coruption of data residing on hugetlbfs (CVE-2021-4002)

* kernel: security regression for CVE-2018-13405 (CVE-2021-4037)

* kernel: Buffer overwrite in decode_nfs_fh function (CVE-2021-4157)

* kernel: cgroup: Use open-time creds and namespace for migration perm checks (CVE-2021-4197)

* kernel: Race condition in races in sk_peer_pid and sk_peer_cred accesses (CVE-2021-4203)

* kernel: new DNS Cache Poisoning Attack based on ICMP fragment needed packets replies (CVE-2021-20322)

* kernel: arm: SIGPAGE information disclosure vulnerability (CVE-2021-21781)

* hw: cpu: LFENCE/JMP Mitigation Update for CVE-2017-5715 (CVE-2021-26401)

* kernel: Local privilege escalation due to incorrect BPF JIT branch displacement computation (CVE-2021-29154)

* kernel: use-after-free in hso_free_net_device() in drivers/net/usb/hso.c (CVE-2021-37159)

* kernel: eBPF multiplication integer overflow in prealloc_elems_and_freelist() in kernel/bpf/stackmap.c leads to out-of-bounds write (CVE-2021-41864)

* kernel: Heap buffer overflow in firedtv driver (CVE-2021-42739)

* kernel: ppc: kvm: allows a malicious KVM guest to crash the host (CVE-2021-43056)

* kernel: an array-index-out-bounds in detach_capi_ctr in drivers/isdn/capi/kcapi.c (CVE-2021-43389)

* kernel: mwifiex_usb_recv() in drivers/net/wireless/marvell/mwifiex/usb.c allows an attacker to cause DoS via crafted USB device (CVE-2021-43976)

* kernel: use-after-free in the TEE subsystem (CVE-2021-44733)

* kernel: information leak in the IPv6 implementation (CVE-2021-45485)

* kernel: information leak in the IPv4 implementation (CVE-2021-45486)

* hw: cpu: intel: Branch History Injection (BHI) (CVE-2022-0001)

* hw: cpu: intel: Intra-Mode BTI (CVE-2022-0002)

* kernel: Local denial of service in bond_ipsec_add_sa (CVE-2022-0286)

* kernel: DoS in sctp_addto_chunk in net/sctp/sm_make_chunk.c (CVE-2022-0322)

* kernel: FUSE allows UAF reads of write() buffers, allowing theft of (partial) /etc/shadow hashes (CVE-2022-1011)

* kernel: use-after-free in nouveau kernel module (CVE-2020-27820)

For more details about the security issue(s), including the impact, a CVSS score, acknowledgments, and other related information, refer to the CVE page(s) listed in the References section.

Additional Changes:

For detailed information on changes in this release, see the Red Hat Enterprise Linux 8.6 Release Notes linked from the References section.',
    7.5, '3.1', 'CVE', '2021-12-25T02:15:06Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/errata/RHSA-2022:1975, https://access.redhat.com/errata/RHSA-2022:1988, https://access.redhat.com/security/cve/CVE-2021-45485', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2021-47491',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2021-47491', 'Medium', 'Packages', '-', 'The kernel packages contain the Linux kernel, the core of any Linux operating system.

Security Fix(es):

* kernel: powerpc: Fix access beyond end of drmem array (CVE-2023-52451)

* kernel: efivarfs: force RO when remounting if SetVariable is not supported (CVE-2023-52463)

* kernel: tracing: Restructure trace_clock_global() to never block (CVE-2021-46939)

* kernel: ext4: avoid online resizing failures due to oversized flex bg (CVE-2023-52622)

* kernel: net/sched: flower: Fix chain template offload (CVE-2024-26669)

* kernel: stmmac: Clear variable when destroying workqueue (CVE-2024-26802)

* kernel: efi: runtime: Fix potential overflow of soft-reserved region size (CVE-2024-26843)

* kernel: quota: Fix potential NULL pointer dereference (CVE-2024-26878)

* kernel: TIPC message reassembly use-after-free remote code execution vulnerability (CVE-2024-36886)

* kernel: SUNRPC: fix a memleak in gss_import_v2_context (CVE-2023-52653)

* kernel: dmaengine/idxd: hardware erratum allows potential security problem with direct access by untrusted application (CVE-2024-21823)

* kernel: Revert &#34;net/mlx5: Block entering switchdev mode with ns inconsistency&#34; (CVE-2023-52658)

* kernel: ext4: fix corruption during on-line resize (CVE-2024-35807)

* kernel: x86/fpu: Keep xfd_state in sync with MSR_IA32_XFD (CVE-2024-35801)

* kernel: dyndbg: fix old BUG_ON in &gt;control parser (CVE-2024-35947)

* kernel: net/sched: act_skbmod: prevent kernel-infoleak (CVE-2024-35893)

* kernel: x86/mce: Make sure to grab mce_sysfs_mutex in set_bank() (CVE-2024-35876)

* kernel: platform/x86: wmi: Fix opening of char device (CVE-2023-52864)

* kernel: tipc: Change nla_policy for bearer-related names to NLA_NUL_STRING (CVE-2023-52845)

* (CVE-2023-28746)
* (CVE-2023-52847)
* (CVE-2021-47548)
* (CVE-2024-36921)
* (CVE-2024-26921)
* (CVE-2021-47579)
* (CVE-2024-36927)
* (CVE-2024-39276)
* (CVE-2024-33621)
* (CVE-2024-27010)
* (CVE-2024-26960)
* (CVE-2024-38596)
* (CVE-2022-48743)
* (CVE-2024-26733)
* (CVE-2024-26586)
* (CVE-2024-26698)
* (CVE-2023-52619)

Bug Fix(es):

* RHEL8.6 - Spinlock statistics may show negative elapsed time and incorrectly formatted output (JIRA:RHEL-17678)

* [AWS][8.9]There are call traces found when booting debug-kernel  for Amazon EC2 r8g.metal-24xl instance (JIRA:RHEL-23841)

* [rhel8] gfs2: Fix glock shrinker (JIRA:RHEL-32941)

* lan78xx: Microchip LAN7800 never comes up after unplug and replug (JIRA:RHEL-33437)

* [Hyper-V][RHEL-8.10.z] Update hv_netvsc driver to TOT (JIRA:RHEL-39074)

* Use-after-free on proc inode-i_sb triggered by fsnotify (JIRA:RHEL-40167)

* blk-cgroup: Properly propagate the iostat update up the hierarchy [rhel-8.10.z] (JIRA:RHEL-40939)

* (JIRA:RHEL-31798)
* (JIRA:RHEL-10263)
* (JIRA:RHEL-40901)
* (JIRA:RHEL-43547)
* (JIRA:RHEL-34876)

Enhancement(s):

* [RFE] Add module parameters ''soft_reboot_cmd'' and ''soft_active_on_boot'' for customizing softdog configuration (JIRA:RHEL-19723)

For more details about the security issue(s), including the impact, a CVSS score, acknowledgments, and other related information, refer the CVE page(s) listed in the References section.',
    5.5, '3.1', 'CVE', '2024-05-22T09:15:10Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/errata/RHSA-2024:5101, https://access.redhat.com/errata/RHSA-2024:5102, https://access.redhat.com/security/cve/CVE-2021-47491', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2024-57938',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2024-57938', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

net/sctp: Prevent autoclose integer overflow in sctp_association_init()

While by default max_autoclose equals to INT_MAX / HZ, one may set
net.sctp.max_autoclose to UINT_MAX. There is code in
sctp_association_init() that can consequently trigger overflow.',
    5.5, '3.1', 'CVE', '2025-01-21T12:15:27Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/security/cve/CVE-2024-57938', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2020-25705',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2020-25705', 'High', 'Packages', '-', 'The kernel packages contain the Linux kernel, the core of any Linux operating system.

Security Fix(es):

* kernel: locking issue in drivers/tty/tty_jobctrl.c can lead to an use-after-free (CVE-2020-29661)

* kernel: performance counters race condition use-after-free (CVE-2020-14351)

* kernel: ICMP rate limiting can be used for DNS poisoning attack (CVE-2020-25705)

For more details about the security issue(s), including the impact, a CVSS score, acknowledgments, and other related information, refer to the CVE page(s) listed in the References section.

Bug Fix(es):

* Final fixes + drop alpha_support flag requirement for Tigerlake (BZ#1882620)

* OVS complains Invalid Argument on TCP packets going into conntrack (BZ#1892744)

* BUG: using smp_processor_id() in preemptible [00000000] code: handler106/3082 (BZ#1893281)

* Icelake performance - add  intel_idle: Customize IceLake server support  to RHEL-8 (BZ#1897183)

* [mlx5] IPV6 TOS rewrite flows are not getting offloaded in HW (BZ#1897688)

* RHEL 8.3 SAS - multipathd fails to re-establish paths during controller random reset (BZ#1900112)

* RHEL8.3 Beta - RHEL8.3 hangs on dbginfo.sh execution, crash dump generated (mm-) (BZ#1903019)

* Win10 guest automatic reboot after migration in Win10 and WSL2 on AMD hosts (BZ#1905084)

* block, dm: fix IO splitting for stacked devices (BZ#1905136)

* Failed to hotplug scsi-hd disks (BZ#1905214)

* PCI quirk needed to prevent GPU hang (BZ#1906516)

* RHEL8.2 - various patches to stabilize the OPAL error log processing and the powernv dump processing (ESS) (BZ#1907301)

* pmtu not working with tunnels as bridge ports and br_netfilter loaded (BZ#1907576)

* [ThinkPad X13/T14/T14s AMD]: Kdump failed (BZ#1907775)

* NFSv4 client improperly handles interrupted slots (BZ#1908312)

* NFSv4.1 client ignores ERR_DELAY during LOCK recovery, could lead to data corruption (BZ#1908313)

* [Regression] RHEL8.2 - [kernel 148.el8] cpu (sys) time regression in SAP HANA 2.0 benchmark benchInsertSubSelectPerformance (BZ#1908519)

* RHEL8: kernel-rt: kernel BUG at kernel/sched/deadline.c:1462! (BZ#1908731)

* SEV VM hang at efi_mokvar_sysfs_init+0xa9/0x19d during boot (BZ#1909243)

* C6gn support requires "Ensure dirty bit is preserved across pte_wrprotect" patch (BZ#1909577)

* [Lenovo 8.3 & 8.4 Bug] [Regression] No response from keyboard and mouse when boot from tboot kernel (BZ#1911555)

* Kernel crash with krb5p (BZ#1912478)

* [RHEL8] Need additional backports for FIPS 800-90A DRBG entropy seeding source (BZ#1912872)

* [Hyper-V][RHEL-8] Request to included a commit that adds a timeout to vmbus_wait_for_unload (BZ#1913528)

* Host becomes unresponsive during stress-ng --cyclic test rcu: INFO: rcu_preempt detected stalls on CPUs/tasks: (BZ#1913964)

* RHEL8.4: Backport upstream RCU patches up to v5.6 (BZ#1915638)

* Missing mm backport to fix regression introduced by another mm backport (BZ#1915814)

* [Hyper-V][RHEL-8]video: hyperv_fb: Fix the cache type when mapping the VRAM Edit (BZ#1917711)

* ionic 0000:39:00.0 ens2: IONIC_CMD_Q_INIT (40) failed: IONIC_RC_ERROR (-5) (BZ#1918372)

* [certification] mlx5_core depends on tls triggering TAINT_TECH_PREVIEW even if no ConnectX-6 card is present (BZ#1918743)

* kvm-rhel8.3 [AMD] - system crash observed while powering on virtual machine with attached VF interfaces. (BZ#1919885)

Enhancement(s):

* [Mellanox 8.4 FEAT] mlx5: Add messages when VF-LAG fails to start (BZ#1892344)',
    7.4, '3.1', 'CVE', '2020-11-17T02:15:13Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/errata/RHSA-2021:0537, https://access.redhat.com/errata/RHSA-2021:0558, https://access.redhat.com/security/cve/CVE-2020-25705', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2021-47424',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2021-47424', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

i40e: Fix freeing of uninitialized misc IRQ vector

When VSI set up failed in i40e_probe() as part of PF switch set up
driver was trying to free misc IRQ vectors in
i40e_clear_interrupt_scheme and produced a kernel Oops:

   Trying to free already-free IRQ 266
   WARNING: CPU: 0 PID: 5 at kernel/irq/manage.c:1731 __free_irq+0x9a/0x300
   Workqueue: events work_for_cpu_fn
   RIP: 0010:__free_irq+0x9a/0x300
   Call Trace:
   ? synchronize_irq+0x3a/0xa0
   free_irq+0x2e/0x60
   i40e_clear_interrupt_scheme+0x53/0x190 [i40e]
   i40e_probe.part.108+0x134b/0x1a40 [i40e]
   ? kmem_cache_alloc+0x158/0x1c0
   ? acpi_ut_update_ref_count.part.1+0x8e/0x345
   ? acpi_ut_update_object_reference+0x15e/0x1e2
   ? strstr+0x21/0x70
   ? irq_get_irq_data+0xa/0x20
   ? mp_check_pin_attr+0x13/0xc0
   ? irq_get_irq_data+0xa/0x20
   ? mp_map_pin_to_irq+0xd3/0x2f0
   ? acpi_register_gsi_ioapic+0x93/0x170
   ? pci_conf1_read+0xa4/0x100
   ? pci_bus_read_config_word+0x49/0x70
   ? do_pci_enable_device+0xcc/0x100
   local_pci_probe+0x41/0x90
   work_for_cpu_fn+0x16/0x20
   process_one_work+0x1a7/0x360
   worker_thread+0x1cf/0x390
   ? create_worker+0x1a0/0x1a0
   kthread+0x112/0x130
   ? kthread_flush_work_fn+0x10/0x10
   ret_from_fork+0x1f/0x40

The problem is that at that point misc IRQ vectors
were not allocated yet and we get a call trace
that driver is trying to free already free IRQ vectors.

Add a check in i40e_clear_interrupt_scheme for __I40E_MISC_IRQ_REQUESTED
PF state before calling i40e_free_misc_vector. This state is set only if
misc IRQ vectors were properly initialized.',
    4.4, '3.1', 'CVE', '2024-05-21T15:15:27Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/security/cve/CVE-2021-47424', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-49644',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-49644', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

drm/i915: fix a possible refcount leak in intel_dp_add_mst_connector()

If drm_connector_init fails, intel_connector_free will be called to take
care of proper free. So it is necessary to drop the refcount of port
before intel_connector_free.

(cherry picked from commit cea9ed611e85d36a05db52b6457bf584b7d969e2)',
    5.5, '3.1', 'CVE', '2025-02-26T07:01:39Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/errata/RHSA-2023:2951, https://access.redhat.com/security/cve/CVE-2022-49644', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-49561',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-49561', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

netfilter: conntrack: re-fetch conntrack after insertion

In case the conntrack is clashing, insertion can free skb->_nfct and
set skb->_nfct to the already-confirmed entry.

This wasn''t found before because the conntrack entry and the extension
space used to free''d after an rcu grace period, plus the race needs
events enabled to trigger.',
    5.5, '3.1', 'CVE', '2025-02-26T07:01:31Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/errata/RHSA-2022:7683, https://access.redhat.com/security/cve/CVE-2022-49561', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-49005',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-49005', 'Medium', 'Packages', '-', 'The MITRE CVE dictionary describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

ASoC: ops: Fix bounds check for _sx controls

For _sx controls the semantics of the max field is not the usual one, max
is the number of steps rather than the maximum value. This means that our
check in snd_soc_put_volsw_sx() needs to just check against the maximum
value.',
    4.4, '3.1', 'CVE', '2024-10-21T20:15:12Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/security/cve/CVE-2022-49005', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2023-53026',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2023-53026', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

RDMA/core: Fix ib block iterator counter overflow

When registering a new DMA MR after selecting the best aligned page size
for it, we iterate over the given sglist to split each entry to smaller,
aligned to the selected page size, DMA blocks.

In given circumstances where the sg entry and page size fit certain
sizes and the sg entry is not aligned to the selected page size, the
total size of the aligned pages we need to cover the sg entry is >= 4GB.
Under this circumstances, while iterating page aligned blocks, the
counter responsible for counting how much we advanced from the start of
the sg entry is overflowed because its type is u32 and we pass 4GB in
size. This can lead to an infinite loop inside the iterator function
because the overflow prevents the counter to be larger
than the size of the sg entry.

Fix the presented problem by changing the advancement condition to
eliminate overflow.

Backtrace:
[  192.374329] efa_reg_user_mr_dmabuf
[  192.376783] efa_register_mr
[  192.382579] pgsz_bitmap 0xfffff000 rounddown 0x80000000
[  192.386423] pg_sz [0x80000000] umem_length[0xc0000000]
[  192.392657] start 0x0 length 0xc0000000 params.page_shift 31 params.page_num 3
[  192.399559] hp_cnt[3], pages_in_hp[524288]
[  192.403690] umem->sgt_append.sgt.nents[1]
[  192.407905] number entries: [1], pg_bit: [31]
[  192.411397] biter->__sg_nents [1] biter->__sg [0000000008b0c5d8]
[  192.415601] biter->__sg_advance [665837568] sg_dma_len[3221225472]
[  192.419823] biter->__sg_nents [1] biter->__sg [0000000008b0c5d8]
[  192.423976] biter->__sg_advance [2813321216] sg_dma_len[3221225472]
[  192.428243] biter->__sg_nents [1] biter->__sg [0000000008b0c5d8]
[  192.432397] biter->__sg_advance [665837568] sg_dma_len[3221225472]',
    5.5, '3.1', 'CVE', '2025-03-27T17:15:52Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/errata/RHSA-2023:7077, https://access.redhat.com/security/cve/CVE-2023-53026', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2025-38118',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2025-38118', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

Bluetooth: MGMT: Fix UAF on mgmt_remove_adv_monitor_complete

This reworks MGMT_OP_REMOVE_ADV_MONITOR to not use mgmt_pending_add to
avoid crashes like bellow:

==================================================================
BUG: KASAN: slab-use-after-free in mgmt_remove_adv_monitor_complete+0xe5/0x540 net/bluetooth/mgmt.c:5406
Read of size 8 at addr ffff88801c53f318 by task kworker/u5:5/5341

CPU: 0 UID: 0 PID: 5341 Comm: kworker/u5:5 Not tainted 6.15.0-syzkaller-10402-g4cb6c8af8591 #0 PREEMPT(full)
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Workqueue: hci0 hci_cmd_sync_work
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:408 [inline]
 print_report+0xd2/0x2b0 mm/kasan/report.c:521
 kasan_report+0x118/0x150 mm/kasan/report.c:634
 mgmt_remove_adv_monitor_complete+0xe5/0x540 net/bluetooth/mgmt.c:5406
 hci_cmd_sync_work+0x261/0x3a0 net/bluetooth/hci_sync.c:334
 process_one_work kernel/workqueue.c:3238 [inline]
 process_scheduled_works+0xade/0x17b0 kernel/workqueue.c:3321
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3402
 kthread+0x711/0x8a0 kernel/kthread.c:464
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Allocated by task 5987:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:394
 kasan_kmalloc include/linux/kasan.h:260 [inline]
 __kmalloc_cache_noprof+0x230/0x3d0 mm/slub.c:4358
 kmalloc_noprof include/linux/slab.h:905 [inline]
 kzalloc_noprof include/linux/slab.h:1039 [inline]
 mgmt_pending_new+0x65/0x240 net/bluetooth/mgmt_util.c:252
 mgmt_pending_add+0x34/0x120 net/bluetooth/mgmt_util.c:279
 remove_adv_monitor+0x103/0x1b0 net/bluetooth/mgmt.c:5454
 hci_mgmt_cmd+0x9c9/0xef0 net/bluetooth/hci_sock.c:1719
 hci_sock_sendmsg+0x6ca/0xef0 net/bluetooth/hci_sock.c:1839
 sock_sendmsg_nosec net/socket.c:712 [inline]
 __sock_sendmsg+0x219/0x270 net/socket.c:727
 sock_write_iter+0x258/0x330 net/socket.c:1131
 new_sync_write fs/read_write.c:593 [inline]
 vfs_write+0x548/0xa90 fs/read_write.c:686
 ksys_write+0x145/0x250 fs/read_write.c:738
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 5989:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:576
 poison_slab_object mm/kasan/common.c:247 [inline]
 __kasan_slab_free+0x62/0x70 mm/kasan/common.c:264
 kasan_slab_free include/linux/kasan.h:233 [inline]
 slab_free_hook mm/slub.c:2380 [inline]
 slab_free mm/slub.c:4642 [inline]
 kfree+0x18e/0x440 mm/slub.c:4841
 mgmt_pending_foreach+0xc9/0x120 net/bluetooth/mgmt_util.c:242
 mgmt_index_removed+0x10d/0x2f0 net/bluetooth/mgmt.c:9366
 hci_sock_bind+0xbe9/0x1000 net/bluetooth/hci_sock.c:1314
 __sys_bind_socket net/socket.c:1810 [inline]
 __sys_bind+0x2c3/0x3e0 net/socket.c:1841
 __do_sys_bind net/socket.c:1846 [inline]
 __se_sys_bind net/socket.c:1844 [inline]
 __x64_sys_bind+0x7a/0x90 net/socket.c:1844
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f',
    5.5, '3.1', 'CVE', '2025-07-03T09:15:25Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/security/cve/CVE-2025-38118', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-28390',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-28390', 'High', 'Packages', '-', 'The kernel packages contain the Linux kernel, the core of any Linux operating system.

Security Fix(es):

* off-path attacker may inject data or terminate victim''s TCP session (CVE-2020-36516)

* race condition in VT_RESIZEX ioctl when vc_cons[i].d is already NULL leading to NULL pointer dereference (CVE-2020-36558)

* use-after-free vulnerability in function sco_sock_sendmsg() (CVE-2021-3640)

* memory leak for large arguments in video_usercopy function in drivers/media/v4l2-core/v4l2-ioctl.c (CVE-2021-30002)

* smb2_ioctl_query_info NULL Pointer Dereference (CVE-2022-0168)

* NULL pointer dereference in udf_expand_file_adinicbdue() during writeback (CVE-2022-0617)

* swiotlb information leak with DMA_FROM_DEVICE (CVE-2022-0854)

* uninitialized registers on stack in nft_do_chain can cause kernel pointer leakage to UM (CVE-2022-1016)

* race condition in snd_pcm_hw_free leading to use-after-free (CVE-2022-1048)

* use-after-free in tc_new_tfilter() in net/sched/cls_api.c (CVE-2022-1055)

* use-after-free and memory errors in ext4 when mounting and operating on a corrupted image (CVE-2022-1184)

* NULL pointer dereference in x86_emulate_insn may lead to DoS (CVE-2022-1852)

* buffer overflow in nft_set_desc_concat_parse() (CVE-2022-2078)

* nf_tables cross-table potential use-after-free may lead to local privilege escalation (CVE-2022-2586)

* openvswitch: integer underflow leads to out-of-bounds write in reserve_sfa_size() (CVE-2022-2639)

* use-after-free when psi trigger is destroyed while being polled (CVE-2022-2938)

* net/packet: slab-out-of-bounds access in packet_recvmsg() (CVE-2022-20368)

* possible to use the debugger to write zero into a location of choice (CVE-2022-21499)

* Spectre-BHB (CVE-2022-23960)

* Post-barrier Return Stack Buffer Predictions (CVE-2022-26373)

* memory leak in drivers/hid/hid-elo.c (CVE-2022-27950)

* double free in ems_usb_start_xmit in drivers/net/can/usb/ems_usb.c (CVE-2022-28390)

* use after free in SUNRPC subsystem (CVE-2022-28893)

* use-after-free due to improper update of reference count in net/sched/cls_u32.c (CVE-2022-29581)

* DoS in nfqnl_mangle in net/netfilter/nfnetlink_queue.c (CVE-2022-36946)

* nfs_atomic_open() returns uninitialized data instead of ENOTDIR (CVE-2022-24448)

For more details about the security issue(s), including the impact, a CVSS score, acknowledgments, and other related information, refer to the CVE page(s) listed in the References section.

Additional Changes:

For detailed information on changes in this release, see the Red Hat Enterprise Linux 8.7 Release Notes linked from the References section.',
    7.0, '3.1', 'CVE', '2022-04-03T21:15:08Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/errata/RHSA-2022:7444, https://access.redhat.com/errata/RHSA-2022:7683, https://access.redhat.com/security/cve/CVE-2022-28390', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-50055',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-50055', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

iavf: Fix adminq error handling

iavf_alloc_asq_bufs/iavf_alloc_arq_bufs allocates with dma_alloc_coherent
memory for VF mailbox.
Free DMA regions for both ASQ and ARQ in case error happens during
configuration of ASQ/ARQ registers.
Without this change it is possible to see when unloading interface:
74626.583369: dma_debug_device_change: device driver has pending DMA allocations while released from device [count=32]
One of leaked entries details: [device address=0x0000000b27ff9000] [size=4096 bytes] [mapped with DMA_BIDIRECTIONAL] [mapped as coherent]',
    4.7, '3.1', 'CVE', '2025-06-18T11:15:34Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/errata/RHSA-2022:7110, https://access.redhat.com/errata/RHSA-2022:7683, https://access.redhat.com/security/cve/CVE-2022-50055', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-48748',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-48748', 'Medium', 'Packages', '-', 'The MITRE CVE dictionary describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

net: bridge: vlan: fix memory leak in __allowed_ingress

When using per-vlan state, if vlan snooping and stats are disabled,
untagged or priority-tagged ingress frame will go to check pvid state.
If the port state is forwarding and the pvid state is not
learning/forwarding, untagged or priority-tagged frame will be dropped
but skb memory is not freed.
Should free skb when __allowed_ingress returns false.',
    6.1, '3.1', 'CVE', '2024-06-20T12:15:13Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/security/cve/CVE-2022-48748', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-49817',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-49817', 'Low', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

net: mhi: Fix memory leak in mhi_net_dellink()

MHI driver registers network device without setting the
needs_free_netdev flag, and does NOT call free_netdev() when
unregisters network device, which causes a memory leak.

This patch calls free_netdev() to fix it since netdev_priv
is used after unregister. 
            This patch fixes a memory leak in the MHI (Modem Host Interface) network driver that occurred when a network device was unregistered without freeing its allocated structure. The driver failed to call free_netdev() after unregister_netdev(), leading to persistent kernel memory consumption each time a device was detached. The issue affects systems using WWAN devices over MHI but does not allow privilege escalation or corruption—only gradual memory exhaustion.',
    2.3, '3.1', 'CVE', '2025-05-01T15:16:05Z', '2026-01-05T16:09:36.535Z',
    'https://access.redhat.com/security/cve/CVE-2022-49817', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-50821',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-50821', 'High', 'Packages', '-', 'No description is available for this CVE.',
    7.0, '3.1', 'CVE', '2000-01-01T00:00:00Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/security/cve/CVE-2022-50821', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-48761',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-48761', 'Medium', 'Packages', '-', 'The MITRE CVE dictionary describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

usb: xhci-plat: fix crash when suspend if remote wake enable

Crashed at i.mx8qm platform when suspend if enable remote wakeup

Internal error: synchronous external abort: 96000210 [#1] PREEMPT SMP
Modules linked in:
CPU: 2 PID: 244 Comm: kworker/u12:6 Not tainted 5.15.5-dirty #12
Hardware name: Freescale i.MX8QM MEK (DT)
Workqueue: events_unbound async_run_entry_fn
pstate: 600000c5 (nZCv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : xhci_disable_hub_port_wake.isra.62+0x60/0xf8
lr : xhci_disable_hub_port_wake.isra.62+0x34/0xf8
sp : ffff80001394bbf0
x29: ffff80001394bbf0 x28: 0000000000000000 x27: ffff00081193b578
x26: ffff00081193b570 x25: 0000000000000000 x24: 0000000000000000
x23: ffff00081193a29c x22: 0000000000020001 x21: 0000000000000001
x20: 0000000000000000 x19: ffff800014e90490 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
x14: 0000000000000000 x13: 0000000000000002 x12: 0000000000000000
x11: 0000000000000000 x10: 0000000000000960 x9 : ffff80001394baa0
x8 : ffff0008145d1780 x7 : ffff0008f95b8e80 x6 : 000000001853b453
x5 : 0000000000000496 x4 : 0000000000000000 x3 : ffff00081193a29c
x2 : 0000000000000001 x1 : 0000000000000000 x0 : ffff000814591620
Call trace:
 xhci_disable_hub_port_wake.isra.62+0x60/0xf8
 xhci_suspend+0x58/0x510
 xhci_plat_suspend+0x50/0x78
 platform_pm_suspend+0x2c/0x78
 dpm_run_callback.isra.25+0x50/0xe8
 __device_suspend+0x108/0x3c0

The basic flow:
	1. run time suspend call xhci_suspend, xhci parent devices gate the clock.
        2. echo mem >/sys/power/state, system _device_suspend call xhci_suspend
        3. xhci_suspend call xhci_disable_hub_port_wake, which access register,
	   but clock already gated by run time suspend.

This problem was hidden by power domain driver, which call run time resume before it.

But the below commit remove it and make this issue happen.
	commit c1df456d0f06e ("PM: domains: Don''t runtime resume devices at genpd_prepare()")

This patch call run time resume before suspend to make sure clock is on
before access register.

Testeb-by: Abel Vesa <abel.vesa@nxp.com>',
    4.4, '3.1', 'CVE', '2024-06-20T12:15:14Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/security/cve/CVE-2022-48761', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2023-42754',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2023-42754', 'Medium', 'Packages', '-', 'The kernel packages contain the Linux kernel, the core of any Linux operating system.

Security Fix(es):

For more details about the security issue(s), including the impact, a CVSS score, acknowledgments, and other related information, refer to the CVE page(s) listed in the References section.

Additional Changes:

For detailed information on changes in this release, see the Red Hat Enterprise Linux 8.10 Release Notes linked from the References section.',
    5.5, '3.1', 'CVE', '2023-10-05T19:15:11Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/errata/RHSA-2024:2950, https://access.redhat.com/errata/RHSA-2024:3138, https://access.redhat.com/security/cve/CVE-2023-42754', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2021-47609',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2021-47609', 'Medium', 'Packages', '-', 'The kernel packages contain the Linux kernel, the core of any Linux operating system.  
Security Fix(es):

 CVE-2023-6040  CVE-2024-26595  CVE-2024-26600  CVE-2021-46984  CVE-2023-52478  CVE-2023-52476  CVE-2023-52522  CVE-2021-47101  CVE-2021-47097  CVE-2023-52605  CVE-2024-26638  CVE-2024-26645  CVE-2024-26665  CVE-2024-26720  CVE-2024-26717  CVE-2024-26769  CVE-2024-26846  CVE-2024-26894  CVE-2024-26880  CVE-2024-26855  CVE-2024-26923  CVE-2024-26939  CVE-2024-27013  CVE-2024-27042  CVE-2024-35809  CVE-2023-52683  CVE-2024-35884  CVE-2024-35877  CVE-2024-35944  CVE-2024-35989  CVE-2021-47412  CVE-2021-47393  CVE-2021-47386  CVE-2021-47385  CVE-2021-47384  CVE-2021-47383  CVE-2021-47432  CVE-2021-47352  CVE-2021-47338  CVE-2021-47321  CVE-2021-47289  CVE-2021-47287  CVE-2023-52798  CVE-2023-52809  CVE-2023-52817  CVE-2023-52840  CVE-2023-52800  CVE-2021-47441  CVE-2021-47466  CVE-2021-47455  CVE-2021-47497  CVE-2021-47560  CVE-2021-47527  CVE-2024-36883  CVE-2024-36922  CVE-2024-36920  CVE-2024-36902  CVE-2024-36953  CVE-2024-36939  CVE-2024-36919  CVE-2024-36901  CVE-2021-47582  CVE-2021-47609  CVE-2024-38619  CVE-2022-48754  CVE-2022-48760  CVE-2024-38581  CVE-2024-38579  CVE-2024-38570  CVE-2024-38559  CVE-2024-38558  CVE-2024-37356  CVE-2024-39471  CVE-2024-39499  CVE-2024-39501  CVE-2024-39506  CVE-2024-40904  CVE-2024-40911  CVE-2024-40912  CVE-2024-40929  CVE-2024-40931  CVE-2024-40941  CVE-2024-40954  CVE-2024-40958  CVE-2024-40959  CVE-2024-40960  CVE-2024-40972  CVE-2024-40977  CVE-2024-40978  CVE-2024-40988  CVE-2024-40989  CVE-2024-40995  CVE-2024-40997  CVE-2024-40998  CVE-2024-41005  CVE-2024-40901  CVE-2024-41007  CVE-2024-41008  CVE-2022-48804  CVE-2022-48836  CVE-2022-48866  CVE-2024-41090  CVE-2024-41091  CVE-2024-41012  CVE-2024-41013  CVE-2024-41014  CVE-2024-41023  CVE-2024-41035  CVE-2024-41038  CVE-2024-41039  CVE-2024-41040  CVE-2024-41041  CVE-2024-41044  CVE-2024-41055  CVE-2024-41056  CVE-2024-41060  CVE-2024-41064  CVE-2024-41065  CVE-2024-41071  CVE-2024-41076  CVE-2024-41097  CVE-2024-42084  CVE-2024-42090  CVE-2024-42094  CVE-2024-42096  CVE-2024-42114  CVE-2024-42124  CVE-2024-42131  CVE-2024-42152  CVE-2024-42154  CVE-2024-42225  CVE-2024-42226  CVE-2024-42228  CVE-2024-42237  CVE-2024-42238  CVE-2024-42240  CVE-2024-42246  CVE-2024-42322  CVE-2024-43830  CVE-2024-43871  For more details about the security issue(s), including the impact, a CVSS score, acknowledgments, and other related information, refer to the CVE page(s) listed in the References section.',
    6.7, '3.1', 'CVE', '2024-06-19T15:15:55Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/errata/RHSA-2024:7000, https://access.redhat.com/errata/RHSA-2024:7001, https://access.redhat.com/security/cve/CVE-2021-47609', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2024-26695',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2024-26695', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

crypto: ccp - Fix null pointer dereference in __sev_platform_shutdown_locked

The SEV platform device can be shutdown with a null psp_master,
e.g., using DEBUG_TEST_DRIVER_REMOVE.  Found using KASAN:

[  137.148210] ccp 0000:23:00.1: enabling device (0000 -> 0002)
[  137.162647] ccp 0000:23:00.1: no command queues available
[  137.170598] ccp 0000:23:00.1: sev enabled
[  137.174645] ccp 0000:23:00.1: psp enabled
[  137.178890] general protection fault, probably for non-canonical address 0xdffffc000000001e: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC KASAN NOPTI
[  137.182693] KASAN: null-ptr-deref in range [0x00000000000000f0-0x00000000000000f7]
[  137.182693] CPU: 93 PID: 1 Comm: swapper/0 Not tainted 6.8.0-rc1+ #311
[  137.182693] RIP: 0010:__sev_platform_shutdown_locked+0x51/0x180
[  137.182693] Code: 08 80 3c 08 00 0f 85 0e 01 00 00 48 8b 1d 67 b6 01 08 48 b8 00 00 00 00 00 fc ff df 48 8d bb f0 00 00 00 48 89 f9 48 c1 e9 03 <80> 3c 01 00 0f 85 fe 00 00 00 48 8b 9b f0 00 00 00 48 85 db 74 2c
[  137.182693] RSP: 0018:ffffc900000cf9b0 EFLAGS: 00010216
[  137.182693] RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 000000000000001e
[  137.182693] RDX: 0000000000000000 RSI: 0000000000000008 RDI: 00000000000000f0
[  137.182693] RBP: ffffc900000cf9c8 R08: 0000000000000000 R09: fffffbfff58f5a66
[  137.182693] R10: ffffc900000cf9c8 R11: ffffffffac7ad32f R12: ffff8881e5052c28
[  137.182693] R13: ffff8881e5052c28 R14: ffff8881758e43e8 R15: ffffffffac64abf8
[  137.182693] FS:  0000000000000000(0000) GS:ffff889de7000000(0000) knlGS:0000000000000000
[  137.182693] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  137.182693] CR2: 0000000000000000 CR3: 0000001cf7c7e000 CR4: 0000000000350ef0
[  137.182693] Call Trace:
[  137.182693]  <TASK>
[  137.182693]  ? show_regs+0x6c/0x80
[  137.182693]  ? __die_body+0x24/0x70
[  137.182693]  ? die_addr+0x4b/0x80
[  137.182693]  ? exc_general_protection+0x126/0x230
[  137.182693]  ? asm_exc_general_protection+0x2b/0x30
[  137.182693]  ? __sev_platform_shutdown_locked+0x51/0x180
[  137.182693]  sev_firmware_shutdown.isra.0+0x1e/0x80
[  137.182693]  sev_dev_destroy+0x49/0x100
[  137.182693]  psp_dev_destroy+0x47/0xb0
[  137.182693]  sp_destroy+0xbb/0x240
[  137.182693]  sp_pci_remove+0x45/0x60
[  137.182693]  pci_device_remove+0xaa/0x1d0
[  137.182693]  device_remove+0xc7/0x170
[  137.182693]  really_probe+0x374/0xbe0
[  137.182693]  ? srso_return_thunk+0x5/0x5f
[  137.182693]  __driver_probe_device+0x199/0x460
[  137.182693]  driver_probe_device+0x4e/0xd0
[  137.182693]  __driver_attach+0x191/0x3d0
[  137.182693]  ? __pfx___driver_attach+0x10/0x10
[  137.182693]  bus_for_each_dev+0x100/0x190
[  137.182693]  ? __pfx_bus_for_each_dev+0x10/0x10
[  137.182693]  ? __kasan_check_read+0x15/0x20
[  137.182693]  ? srso_return_thunk+0x5/0x5f
[  137.182693]  ? _raw_spin_unlock+0x27/0x50
[  137.182693]  driver_attach+0x41/0x60
[  137.182693]  bus_add_driver+0x2a8/0x580
[  137.182693]  driver_register+0x141/0x480
[  137.182693]  __pci_register_driver+0x1d6/0x2a0
[  137.182693]  ? srso_return_thunk+0x5/0x5f
[  137.182693]  ? esrt_sysfs_init+0x1cd/0x5d0
[  137.182693]  ? __pfx_sp_mod_init+0x10/0x10
[  137.182693]  sp_pci_init+0x22/0x30
[  137.182693]  sp_mod_init+0x14/0x30
[  137.182693]  ? __pfx_sp_mod_init+0x10/0x10
[  137.182693]  do_one_initcall+0xd1/0x470
[  137.182693]  ? __pfx_do_one_initcall+0x10/0x10
[  137.182693]  ? parameq+0x80/0xf0
[  137.182693]  ? srso_return_thunk+0x5/0x5f
[  137.182693]  ? __kmalloc+0x3b0/0x4e0
[  137.182693]  ? kernel_init_freeable+0x92d/0x1050
[  137.182693]  ? kasan_populate_vmalloc_pte+0x171/0x190
[  137.182693]  ? srso_return_thunk+0x5/0x5f
[  137.182693]  kernel_init_freeable+0xa64/0x1050
[  137.182693]  ? __pfx_kernel_init+0x10/0x10
[  137.182693]  kernel_init+0x24/0x160
[  137.182693]  ? __switch_to_asm+0x3e/0x70
[  137.182693]  ret_from_fork+0x40/0x80
[  137.182693]  ? __pfx_kernel_init+0x1
---truncated---',
    4.1, '3.1', 'CVE', '2024-04-03T15:15:52Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/security/cve/CVE-2024-26695', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2021-47427',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2021-47427', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

scsi: iscsi: Fix iscsi_task use after free

Commit d39df158518c ("scsi: iscsi: Have abort handler get ref to conn")
added iscsi_get_conn()/iscsi_put_conn() calls during abort handling but
then also changed the handling of the case where we detect an already
completed task where we now end up doing a goto to the common put/cleanup
code. This results in a iscsi_task use after free, because the common
cleanup code will do a put on the iscsi_task.

This reverts the goto and moves the iscsi_get_conn() to after we''ve checked
if the iscsi_task is valid.',
    4.4, '3.1', 'CVE', '2024-05-21T15:15:28Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/security/cve/CVE-2021-47427', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-1016',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-1016', 'Medium', 'Packages', '-', 'The kernel packages contain the Linux kernel, the core of any Linux operating system.

Security Fix(es):

* off-path attacker may inject data or terminate victim''s TCP session (CVE-2020-36516)

* race condition in VT_RESIZEX ioctl when vc_cons[i].d is already NULL leading to NULL pointer dereference (CVE-2020-36558)

* use-after-free vulnerability in function sco_sock_sendmsg() (CVE-2021-3640)

* memory leak for large arguments in video_usercopy function in drivers/media/v4l2-core/v4l2-ioctl.c (CVE-2021-30002)

* smb2_ioctl_query_info NULL Pointer Dereference (CVE-2022-0168)

* NULL pointer dereference in udf_expand_file_adinicbdue() during writeback (CVE-2022-0617)

* swiotlb information leak with DMA_FROM_DEVICE (CVE-2022-0854)

* uninitialized registers on stack in nft_do_chain can cause kernel pointer leakage to UM (CVE-2022-1016)

* race condition in snd_pcm_hw_free leading to use-after-free (CVE-2022-1048)

* use-after-free in tc_new_tfilter() in net/sched/cls_api.c (CVE-2022-1055)

* use-after-free and memory errors in ext4 when mounting and operating on a corrupted image (CVE-2022-1184)

* NULL pointer dereference in x86_emulate_insn may lead to DoS (CVE-2022-1852)

* buffer overflow in nft_set_desc_concat_parse() (CVE-2022-2078)

* nf_tables cross-table potential use-after-free may lead to local privilege escalation (CVE-2022-2586)

* openvswitch: integer underflow leads to out-of-bounds write in reserve_sfa_size() (CVE-2022-2639)

* use-after-free when psi trigger is destroyed while being polled (CVE-2022-2938)

* net/packet: slab-out-of-bounds access in packet_recvmsg() (CVE-2022-20368)

* possible to use the debugger to write zero into a location of choice (CVE-2022-21499)

* Spectre-BHB (CVE-2022-23960)

* Post-barrier Return Stack Buffer Predictions (CVE-2022-26373)

* memory leak in drivers/hid/hid-elo.c (CVE-2022-27950)

* double free in ems_usb_start_xmit in drivers/net/can/usb/ems_usb.c (CVE-2022-28390)

* use after free in SUNRPC subsystem (CVE-2022-28893)

* use-after-free due to improper update of reference count in net/sched/cls_u32.c (CVE-2022-29581)

* DoS in nfqnl_mangle in net/netfilter/nfnetlink_queue.c (CVE-2022-36946)

* nfs_atomic_open() returns uninitialized data instead of ENOTDIR (CVE-2022-24448)

For more details about the security issue(s), including the impact, a CVSS score, acknowledgments, and other related information, refer to the CVE page(s) listed in the References section.

Additional Changes:

For detailed information on changes in this release, see the Red Hat Enterprise Linux 8.7 Release Notes linked from the References section.',
    5.5, '3.1', 'CVE', '2022-08-29T15:15:10Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/errata/RHSA-2022:7444, https://access.redhat.com/errata/RHSA-2022:7683, https://access.redhat.com/security/cve/CVE-2022-1016', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-50701',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-50701', 'High', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

wifi: mt76: mt7921s: fix slab-out-of-bounds access in sdio host

SDIO may need addtional 511 bytes to align bus operation. If the tailroom
of this skb is not big enough, we would access invalid memory region.
For low level operation, increase skb size to keep valid memory access in
SDIO host.

Error message:
[69.951] BUG: KASAN: slab-out-of-bounds in sg_copy_buffer+0xe9/0x1a0
[69.951] Read of size 64 at addr ffff88811c9cf000 by task kworker/u16:7/451
[69.951] CPU: 4 PID: 451 Comm: kworker/u16:7 Tainted: G W  OE  6.1.0-rc5 #1
[69.951] Workqueue: kvub300c vub300_cmndwork_thread [vub300]
[69.951] Call Trace:
[69.951]  <TASK>
[69.952]  dump_stack_lvl+0x49/0x63
[69.952]  print_report+0x171/0x4a8
[69.952]  kasan_report+0xb4/0x130
[69.952]  kasan_check_range+0x149/0x1e0
[69.952]  memcpy+0x24/0x70
[69.952]  sg_copy_buffer+0xe9/0x1a0
[69.952]  sg_copy_to_buffer+0x12/0x20
[69.952]  __command_write_data.isra.0+0x23c/0xbf0 [vub300]
[69.952]  vub300_cmndwork_thread+0x17f3/0x58b0 [vub300]
[69.952]  process_one_work+0x7ee/0x1320
[69.952]  worker_thread+0x53c/0x1240
[69.952]  kthread+0x2b8/0x370
[69.952]  ret_from_fork+0x1f/0x30
[69.952]  </TASK>

[69.952] Allocated by task 854:
[69.952]  kasan_save_stack+0x26/0x50
[69.952]  kasan_set_track+0x25/0x30
[69.952]  kasan_save_alloc_info+0x1b/0x30
[69.952]  __kasan_kmalloc+0x87/0xa0
[69.952]  __kmalloc_node_track_caller+0x63/0x150
[69.952]  kmalloc_reserve+0x31/0xd0
[69.952]  __alloc_skb+0xfc/0x2b0
[69.952]  __mt76_mcu_msg_alloc+0xbf/0x230 [mt76]
[69.952]  mt76_mcu_send_and_get_msg+0xab/0x110 [mt76]
[69.952]  __mt76_mcu_send_firmware.cold+0x94/0x15d [mt76]
[69.952]  mt76_connac_mcu_send_ram_firmware+0x415/0x54d [mt76_connac_lib]
[69.952]  mt76_connac2_load_ram.cold+0x118/0x4bc [mt76_connac_lib]
[69.952]  mt7921_run_firmware.cold+0x2e9/0x405 [mt7921_common]
[69.952]  mt7921s_mcu_init+0x45/0x80 [mt7921s]
[69.953]  mt7921_init_work+0xe1/0x2a0 [mt7921_common]
[69.953]  process_one_work+0x7ee/0x1320
[69.953]  worker_thread+0x53c/0x1240
[69.953]  kthread+0x2b8/0x370
[69.953]  ret_from_fork+0x1f/0x30
[69.953] The buggy address belongs to the object at ffff88811c9ce800
             which belongs to the cache kmalloc-2k of size 2048
[69.953] The buggy address is located 0 bytes to the right of
             2048-byte region [ffff88811c9ce800, ffff88811c9cf000)

[69.953] Memory state around the buggy address:
[69.953]  ffff88811c9cef00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[69.953]  ffff88811c9cef80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[69.953] >ffff88811c9cf000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[69.953]                    ^
[69.953]  ffff88811c9cf080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[69.953]  ffff88811c9cf100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc',
    7.0, '3.1', 'CVE', '2000-01-01T00:00:00Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/security/cve/CVE-2022-50701', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-49890',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-49890', 'Medium', 'Packages', '-', 'A flaw was found in the capabilities subsystem in the Linux kernel. When memory is allocated for a temporary buffer and a subsequent function call fails, the allocated memory is not released, resulting in a memory leak. This issue could impact system performance and result in a denial of service. 
            This issue has been fixed in Red Hat Enterprise Linux 8.9 via RHSA-2023:7077 [1].

The capabilities subsystem as shipped in Red Hat Enterprise Linux 9 is not affected by this vulnerability because the vulnerable code is not present.

[1]. https://access.redhat.com/errata/RHSA-2023:7077',
    5.5, '3.1', 'CVE', '2025-05-01T15:16:14Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/errata/RHSA-2023:7077, https://access.redhat.com/security/cve/CVE-2022-49890', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2021-47456',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2021-47456', 'Medium', 'Packages', '-', 'The kernel packages contain the Linux kernel, the core of any Linux operating system.

Security Fix(es):

* kernel: Bluetooth BR/EDR PIN Pairing procedure is vulnerable to an impersonation attack (CVE-2020-26555)

* kernel: TCP-spoofed ghost ACKs and leak leak initial sequence number (CVE-2023-52881,RHV-2024-1001)

* kernel: ovl: fix leaked entry (CVE-2021-46972)

* kernel: platform/x86: dell-smbios-wmi: Fix oops on rmmod dell_smbios (CVE-2021-47073)

* kernel: gro: fix ownership transfer (CVE-2024-35890)

* kernel: tls: (CVE-2024-26584, CVE-2024-26583, CVE-2024-26585)

* kernel: wifi: (CVE-2024-35789, CVE-2024-27410, CVE-2024-35838, CVE-2024-35845)

* kernel: mlxsw: (CVE-2024-35855, CVE-2024-35854, CVE-2024-35853, CVE-2024-35852, CVE-2024-36007)

* kernel: PCI interrupt mapping cause oops [rhel-8] (CVE-2021-46909)

* kernel: ipc/mqueue, msg, sem: avoid relying on a stack reference past its expiry (CVE-2021-47069)

* kernel: hwrng: core - Fix page fault dead lock on mmap-ed hwrng [rhel-8] (CVE-2023-52615)

* kernel: net/mlx5e: (CVE-2023-52626, CVE-2024-35835, CVE-2023-52667, CVE-2024-35959)

* kernel: drm/amdgpu: use-after-free vulnerability (CVE-2024-26656)

* kernel: Bluetooth: Avoid potential use-after-free in hci_error_reset [rhel-8] (CVE-2024-26801)

* kernel: Squashfs: check the inode number is not the invalid value of zero (CVE-2024-26982)

* kernel: netfilter: nf_tables: use timestamp to check for set element timeout [rhel-8.10] (CVE-2024-27397)

* kernel: mm/damon/vaddr-test: memory leak in damon_do_test_apply_three_regions() (CVE-2023-52560)

* kernel: ppp_async: limit MRU to 64K (CVE-2024-26675)

* kernel: x86/mm/swap: (CVE-2024-26759, CVE-2024-26906)

* kernel: tipc: fix kernel warning when sending SYN message [rhel-8] (CVE-2023-52700)

* kernel: RDMA/mlx5: Fix fortify source warning while accessing Eth segment (CVE-2024-26907)

* kernel: erspan: make sure erspan_base_hdr is present in skb-&gt;head (CVE-2024-35888)

* kernel: powerpc/imc-pmu/powernv: (CVE-2023-52675, CVE-2023-52686)

* kernel: KVM: SVM: improper check in svm_set_x2apic_msr_interception allows direct access to host x2apic msrs (CVE-2023-5090)

* kernel: EDAC/thunderx: Incorrect buffer size in drivers/edac/thunderx_edac.c (CVE-2023-52464)

* kernel: ipv6: sr: fix possible use-after-free and null-ptr-deref (CVE-2024-26735)

* kernel: mptcp: fix data re-injection from stale subflow (CVE-2024-26826)

* kernel: crypto: (CVE-2024-26974, CVE-2023-52669, CVE-2023-52813)

* kernel: net/mlx5/bnx2x/usb: (CVE-2024-35960, CVE-2024-35958, CVE-2021-47310, CVE-2024-26804, CVE-2021-47311, CVE-2024-26859, CVE-2021-47236, CVE-2023-52703)

* kernel: i40e: Do not use WQ_MEM_RECLAIM flag for workqueue (CVE-2024-36004)

* kernel: perf/core: Bail out early if the request AUX area is out of bound (CVE-2023-52835)

* kernel: USB/usbnet: (CVE-2023-52781, CVE-2023-52877, CVE-2021-47495)

* kernel: can: (CVE-2023-52878, CVE-2021-47456)

* kernel: mISDN: fix possible use-after-free in HFC_cleanup() (CVE-2021-47356)

* kernel: udf: Fix NULL pointer dereference in udf_symlink function (CVE-2021-47353)

Bug Fix(es):

* Kernel panic - kernel BUG at mm/slub.c:376! (JIRA:RHEL-29783)

* Temporary values in FIPS integrity test should be zeroized [rhel-8.10.z] (JIRA:RHEL-35361)

* RHEL8.6 - kernel: s390/cpum_cf: make crypto counters upward compatible (JIRA:RHEL-36048)

* [RHEL8] blktests block/024 failed (JIRA:RHEL-8130)

* RHEL8.9: EEH injections results  Error:  Power fault on Port 0 and other call traces(Everest/1050/Shiner) (JIRA:RHEL-14195)

* Latency spikes with Matrox G200 graphic cards (JIRA:RHEL-36172)

For more details about the security issue(s), including the impact, a CVSS score, acknowledgments, and other related information, refer to the CVE page(s) listed in the References section.',
    5.5, '3.1', 'CVE', '2024-05-22T07:15:10Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/errata/RHSA-2024:4211, https://access.redhat.com/errata/RHSA-2024:4352, https://access.redhat.com/security/cve/CVE-2021-47456', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2024-27017',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2024-27017', 'Medium', 'Packages', '-', 'The kernel packages contain the Linux kernel, the core of any Linux operating system.

Security Fix(es):

* kernel: net/bluetooth: race condition in conn_info_{min,max}_age_set() (CVE-2024-24857)

* kernel: dmaengine: fix NULL pointer in channel unregistration function (CVE-2023-52492)

* kernel: netfilter: nf_conntrack_h323: Add protection for bmp length out of range (CVE-2024-26851)

* kernel: netfilter: nft_set_pipapo: do not free live element (CVE-2024-26924)

* kernel: netfilter: nft_set_pipapo: walk over current view on netlink dump (CVE-2024-27017)

* kernel: KVM: Always flush async #PF workqueue when vCPU is being destroyed (CVE-2024-26976)

* kernel: nouveau: lock the client object tree. (CVE-2024-27062)

* kernel: netfilter: bridge: replace physindev with physinif in nf_bridge_info (CVE-2024-35839)

* kernel: netfilter: nf_tables: Fix potential data-race in __nft_flowtable_type_get() (CVE-2024-35898)

* kernel: dma-direct: Leak pages on dma_set_decrypted() failure (CVE-2024-35939)

* kernel: net/mlx5e: Fix netif state handling (CVE-2024-38608)

* kernel: r8169: Fix possible ring buffer corruption on fragmented Tx packets. (CVE-2024-38586)

* kernel: of: module: add buffer overflow check in of_modalias() (CVE-2024-38541)

* kernel: bnxt_re: avoid shift undefined behavior in bnxt_qplib_alloc_init_hwq (CVE-2024-38540)

* kernel: netfilter: ipset: Fix race between namespace cleanup and gc in the list:set type (CVE-2024-39503)

* kernel: drm/i915/dpt: Make DPT object unshrinkable (CVE-2024-40924)

* kernel: ipv6: prevent possible NULL deref in fib6_nh_init() (CVE-2024-40961)

* kernel: tipc: force a dst refcount before doing decryption (CVE-2024-40983)

* kernel: ACPICA: Revert &#34;ACPICA: avoid Info: mapping multiple BARs. Your kernel is fine.&#34; (CVE-2024-40984)

* kernel: xprtrdma: fix pointer derefs in error cases of rpcrdma_ep_create (CVE-2022-48773)

* kernel: bpf: Fix overrunning reservations in ringbuf (CVE-2024-41009)

* kernel: netfilter: nf_tables: prefer nft_chain_validate (CVE-2024-41042)

* kernel: ibmvnic: Add tx check to prevent skb leak (CVE-2024-41066)

* kernel: drm/i915/gt: Fix potential UAF by revoke of fence registers (CVE-2024-41092)

* kernel: drm/amdgpu: avoid using null object of framebuffer (CVE-2024-41093)

* kernel: netfilter: nf_tables: fully validate NFT_DATA_VALUE on store to data registers (CVE-2024-42070)

* kernel: gfs2: Fix NULL pointer dereference in gfs2_log_flush (CVE-2024-42079)

* kernel: USB: serial: mos7840: fix crash on resume (CVE-2024-42244)

* kernel: tipc: Return non-zero value from tipc_udp_addr2str() on error (CVE-2024-42284)

* kernel: kobject_uevent: Fix OOB access within zap_modalias_env() (CVE-2024-42292)

* kernel: dev/parport: fix the array out-of-bounds risk (CVE-2024-42301)

* kernel: block: initialize integrity buffer to zero before writing it to media (CVE-2024-43854)

* kernel: mlxsw: spectrum_acl_erp: Fix object nesting warning (CVE-2024-43880)

* kernel: gso: do not skip outer ip header in case of ipip and net_failover (CVE-2022-48936)

* kernel: padata: Fix possible divide-by-0 panic in padata_mt_helper() (CVE-2024-43889)

* kernel: memcg: protect concurrent access to mem_cgroup_idr (CVE-2024-43892)

* kernel: sctp: Fix null-ptr-deref in reuseport_add_sock(). (CVE-2024-44935)

* kernel: bonding: fix xfrm real_dev null pointer dereference (CVE-2024-44989)

* kernel: bonding: fix null pointer deref in bond_ipsec_offload_ok (CVE-2024-44990)

* kernel: netfilter: flowtable: initialise extack before use (CVE-2024-45018)

* kernel: ELF: fix kernel.randomize_va_space double read (CVE-2024-46826)

* kernel: lib/generic-radix-tree.c: Fix rare race in __genradix_ptr_alloc() (CVE-2024-47668)

For more details about the security issue(s), including the impact, a CVSS score, acknowledgments, and other related information, refer to the CVE page(s) listed in the References section.',
    5.5, '3.1', 'CVE', '2024-05-01T06:15:20Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/errata/RHSA-2024:8856, https://access.redhat.com/errata/RHSA-2024:8870, https://access.redhat.com/security/cve/CVE-2024-27017', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-48632',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-48632', 'Medium', 'Packages', '-', 'The kernel packages contain the Linux kernel, the core of any Linux operating system.

Security Fix(es):

* kernel: powerpc: Fix access beyond end of drmem array (CVE-2023-52451)

* kernel: efivarfs: force RO when remounting if SetVariable is not supported (CVE-2023-52463)

* kernel: tracing: Restructure trace_clock_global() to never block (CVE-2021-46939)

* kernel: ext4: avoid online resizing failures due to oversized flex bg (CVE-2023-52622)

* kernel: net/sched: flower: Fix chain template offload (CVE-2024-26669)

* kernel: stmmac: Clear variable when destroying workqueue (CVE-2024-26802)

* kernel: efi: runtime: Fix potential overflow of soft-reserved region size (CVE-2024-26843)

* kernel: quota: Fix potential NULL pointer dereference (CVE-2024-26878)

* kernel: TIPC message reassembly use-after-free remote code execution vulnerability (CVE-2024-36886)

* kernel: SUNRPC: fix a memleak in gss_import_v2_context (CVE-2023-52653)

* kernel: dmaengine/idxd: hardware erratum allows potential security problem with direct access by untrusted application (CVE-2024-21823)

* kernel: Revert &#34;net/mlx5: Block entering switchdev mode with ns inconsistency&#34; (CVE-2023-52658)

* kernel: ext4: fix corruption during on-line resize (CVE-2024-35807)

* kernel: x86/fpu: Keep xfd_state in sync with MSR_IA32_XFD (CVE-2024-35801)

* kernel: dyndbg: fix old BUG_ON in &gt;control parser (CVE-2024-35947)

* kernel: net/sched: act_skbmod: prevent kernel-infoleak (CVE-2024-35893)

* kernel: x86/mce: Make sure to grab mce_sysfs_mutex in set_bank() (CVE-2024-35876)

* kernel: platform/x86: wmi: Fix opening of char device (CVE-2023-52864)

* kernel: tipc: Change nla_policy for bearer-related names to NLA_NUL_STRING (CVE-2023-52845)

* (CVE-2023-28746)
* (CVE-2023-52847)
* (CVE-2021-47548)
* (CVE-2024-36921)
* (CVE-2024-26921)
* (CVE-2021-47579)
* (CVE-2024-36927)
* (CVE-2024-39276)
* (CVE-2024-33621)
* (CVE-2024-27010)
* (CVE-2024-26960)
* (CVE-2024-38596)
* (CVE-2022-48743)
* (CVE-2024-26733)
* (CVE-2024-26586)
* (CVE-2024-26698)
* (CVE-2023-52619)

Bug Fix(es):

* RHEL8.6 - Spinlock statistics may show negative elapsed time and incorrectly formatted output (JIRA:RHEL-17678)

* [AWS][8.9]There are call traces found when booting debug-kernel  for Amazon EC2 r8g.metal-24xl instance (JIRA:RHEL-23841)

* [rhel8] gfs2: Fix glock shrinker (JIRA:RHEL-32941)

* lan78xx: Microchip LAN7800 never comes up after unplug and replug (JIRA:RHEL-33437)

* [Hyper-V][RHEL-8.10.z] Update hv_netvsc driver to TOT (JIRA:RHEL-39074)

* Use-after-free on proc inode-i_sb triggered by fsnotify (JIRA:RHEL-40167)

* blk-cgroup: Properly propagate the iostat update up the hierarchy [rhel-8.10.z] (JIRA:RHEL-40939)

* (JIRA:RHEL-31798)
* (JIRA:RHEL-10263)
* (JIRA:RHEL-40901)
* (JIRA:RHEL-43547)
* (JIRA:RHEL-34876)

Enhancement(s):

* [RFE] Add module parameters ''soft_reboot_cmd'' and ''soft_active_on_boot'' for customizing softdog configuration (JIRA:RHEL-19723)

For more details about the security issue(s), including the impact, a CVSS score, acknowledgments, and other related information, refer the CVE page(s) listed in the References section.',
    4.7, '3.1', 'CVE', '2024-04-28T13:15:06Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/errata/RHSA-2024:5101, https://access.redhat.com/errata/RHSA-2024:5102, https://access.redhat.com/security/cve/CVE-2022-48632', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-49822',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-49822', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

cifs: Fix connections leak when tlink setup failed

If the tlink setup failed, lost to put the connections, then
the module refcnt leak since the cifsd kthread not exit.

Also leak the fscache info, and for next mount with fsc, it will
print the follow errors:
  CIFS: Cache volume key already in use (cifs,127.0.0.1:445,TEST)

Let''s check the result of tlink setup, and do some cleanup. 
            A resource leak was identified in the CIFS filesystem module due to missing cleanup when tlink setup fails during mount. This causes leaked module references, persistent kernel threads, and leftover fscache entries that may block subsequent mounts.',
    5.5, '3.1', 'CVE', '2025-05-01T15:16:05Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/security/cve/CVE-2022-49822', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2024-40984',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2024-40984', 'Medium', 'Packages', '-', 'The kernel packages contain the Linux kernel, the core of any Linux operating system.

Security Fix(es):

* kernel: net/bluetooth: race condition in conn_info_{min,max}_age_set() (CVE-2024-24857)

* kernel: dmaengine: fix NULL pointer in channel unregistration function (CVE-2023-52492)

* kernel: netfilter: nf_conntrack_h323: Add protection for bmp length out of range (CVE-2024-26851)

* kernel: netfilter: nft_set_pipapo: do not free live element (CVE-2024-26924)

* kernel: netfilter: nft_set_pipapo: walk over current view on netlink dump (CVE-2024-27017)

* kernel: KVM: Always flush async #PF workqueue when vCPU is being destroyed (CVE-2024-26976)

* kernel: nouveau: lock the client object tree. (CVE-2024-27062)

* kernel: netfilter: bridge: replace physindev with physinif in nf_bridge_info (CVE-2024-35839)

* kernel: netfilter: nf_tables: Fix potential data-race in __nft_flowtable_type_get() (CVE-2024-35898)

* kernel: dma-direct: Leak pages on dma_set_decrypted() failure (CVE-2024-35939)

* kernel: net/mlx5e: Fix netif state handling (CVE-2024-38608)

* kernel: r8169: Fix possible ring buffer corruption on fragmented Tx packets. (CVE-2024-38586)

* kernel: of: module: add buffer overflow check in of_modalias() (CVE-2024-38541)

* kernel: bnxt_re: avoid shift undefined behavior in bnxt_qplib_alloc_init_hwq (CVE-2024-38540)

* kernel: netfilter: ipset: Fix race between namespace cleanup and gc in the list:set type (CVE-2024-39503)

* kernel: drm/i915/dpt: Make DPT object unshrinkable (CVE-2024-40924)

* kernel: ipv6: prevent possible NULL deref in fib6_nh_init() (CVE-2024-40961)

* kernel: tipc: force a dst refcount before doing decryption (CVE-2024-40983)

* kernel: ACPICA: Revert &#34;ACPICA: avoid Info: mapping multiple BARs. Your kernel is fine.&#34; (CVE-2024-40984)

* kernel: xprtrdma: fix pointer derefs in error cases of rpcrdma_ep_create (CVE-2022-48773)

* kernel: bpf: Fix overrunning reservations in ringbuf (CVE-2024-41009)

* kernel: netfilter: nf_tables: prefer nft_chain_validate (CVE-2024-41042)

* kernel: ibmvnic: Add tx check to prevent skb leak (CVE-2024-41066)

* kernel: drm/i915/gt: Fix potential UAF by revoke of fence registers (CVE-2024-41092)

* kernel: drm/amdgpu: avoid using null object of framebuffer (CVE-2024-41093)

* kernel: netfilter: nf_tables: fully validate NFT_DATA_VALUE on store to data registers (CVE-2024-42070)

* kernel: gfs2: Fix NULL pointer dereference in gfs2_log_flush (CVE-2024-42079)

* kernel: USB: serial: mos7840: fix crash on resume (CVE-2024-42244)

* kernel: tipc: Return non-zero value from tipc_udp_addr2str() on error (CVE-2024-42284)

* kernel: kobject_uevent: Fix OOB access within zap_modalias_env() (CVE-2024-42292)

* kernel: dev/parport: fix the array out-of-bounds risk (CVE-2024-42301)

* kernel: block: initialize integrity buffer to zero before writing it to media (CVE-2024-43854)

* kernel: mlxsw: spectrum_acl_erp: Fix object nesting warning (CVE-2024-43880)

* kernel: gso: do not skip outer ip header in case of ipip and net_failover (CVE-2022-48936)

* kernel: padata: Fix possible divide-by-0 panic in padata_mt_helper() (CVE-2024-43889)

* kernel: memcg: protect concurrent access to mem_cgroup_idr (CVE-2024-43892)

* kernel: sctp: Fix null-ptr-deref in reuseport_add_sock(). (CVE-2024-44935)

* kernel: bonding: fix xfrm real_dev null pointer dereference (CVE-2024-44989)

* kernel: bonding: fix null pointer deref in bond_ipsec_offload_ok (CVE-2024-44990)

* kernel: netfilter: flowtable: initialise extack before use (CVE-2024-45018)

* kernel: ELF: fix kernel.randomize_va_space double read (CVE-2024-46826)

* kernel: lib/generic-radix-tree.c: Fix rare race in __genradix_ptr_alloc() (CVE-2024-47668)

For more details about the security issue(s), including the impact, a CVSS score, acknowledgments, and other related information, refer to the CVE page(s) listed in the References section.',
    5.5, '3.1', 'CVE', '2024-07-12T13:15:19Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/errata/RHSA-2024:8856, https://access.redhat.com/errata/RHSA-2024:8870, https://access.redhat.com/security/cve/CVE-2024-40984', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2021-47464',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2021-47464', 'Medium', 'Packages', '-', 'The MITRE CVE dictionary describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

audit: fix possible null-pointer dereference in audit_filter_rules

Fix  possible null-pointer dereference in audit_filter_rules.

audit_filter_rules() error: we previously assumed ''ctx'' could be null',
    4.4, '3.1', 'CVE', '2024-05-22T07:15:11Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/security/cve/CVE-2021-47464', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2021-47465',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2021-47465', 'Medium', 'Packages', '-', 'A possible stack corruption flaw was found in the Linux kernel in idle_kvm_start_guest(). This issue may lead to compromised availability.',
    4.4, '3.1', 'CVE', '2024-05-22T07:15:11Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/security/cve/CVE-2021-47465', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2021-47289',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2021-47289', 'Medium', 'Packages', '-', 'The kernel packages contain the Linux kernel, the core of any Linux operating system.  
Security Fix(es):

 CVE-2023-6040  CVE-2024-26595  CVE-2024-26600  CVE-2021-46984  CVE-2023-52478  CVE-2023-52476  CVE-2023-52522  CVE-2021-47101  CVE-2021-47097  CVE-2023-52605  CVE-2024-26638  CVE-2024-26645  CVE-2024-26665  CVE-2024-26720  CVE-2024-26717  CVE-2024-26769  CVE-2024-26846  CVE-2024-26894  CVE-2024-26880  CVE-2024-26855  CVE-2024-26923  CVE-2024-26939  CVE-2024-27013  CVE-2024-27042  CVE-2024-35809  CVE-2023-52683  CVE-2024-35884  CVE-2024-35877  CVE-2024-35944  CVE-2024-35989  CVE-2021-47412  CVE-2021-47393  CVE-2021-47386  CVE-2021-47385  CVE-2021-47384  CVE-2021-47383  CVE-2021-47432  CVE-2021-47352  CVE-2021-47338  CVE-2021-47321  CVE-2021-47289  CVE-2021-47287  CVE-2023-52798  CVE-2023-52809  CVE-2023-52817  CVE-2023-52840  CVE-2023-52800  CVE-2021-47441  CVE-2021-47466  CVE-2021-47455  CVE-2021-47497  CVE-2021-47560  CVE-2021-47527  CVE-2024-36883  CVE-2024-36922  CVE-2024-36920  CVE-2024-36902  CVE-2024-36953  CVE-2024-36939  CVE-2024-36919  CVE-2024-36901  CVE-2021-47582  CVE-2021-47609  CVE-2024-38619  CVE-2022-48754  CVE-2022-48760  CVE-2024-38581  CVE-2024-38579  CVE-2024-38570  CVE-2024-38559  CVE-2024-38558  CVE-2024-37356  CVE-2024-39471  CVE-2024-39499  CVE-2024-39501  CVE-2024-39506  CVE-2024-40904  CVE-2024-40911  CVE-2024-40912  CVE-2024-40929  CVE-2024-40931  CVE-2024-40941  CVE-2024-40954  CVE-2024-40958  CVE-2024-40959  CVE-2024-40960  CVE-2024-40972  CVE-2024-40977  CVE-2024-40978  CVE-2024-40988  CVE-2024-40989  CVE-2024-40995  CVE-2024-40997  CVE-2024-40998  CVE-2024-41005  CVE-2024-40901  CVE-2024-41007  CVE-2024-41008  CVE-2022-48804  CVE-2022-48836  CVE-2022-48866  CVE-2024-41090  CVE-2024-41091  CVE-2024-41012  CVE-2024-41013  CVE-2024-41014  CVE-2024-41023  CVE-2024-41035  CVE-2024-41038  CVE-2024-41039  CVE-2024-41040  CVE-2024-41041  CVE-2024-41044  CVE-2024-41055  CVE-2024-41056  CVE-2024-41060  CVE-2024-41064  CVE-2024-41065  CVE-2024-41071  CVE-2024-41076  CVE-2024-41097  CVE-2024-42084  CVE-2024-42090  CVE-2024-42094  CVE-2024-42096  CVE-2024-42114  CVE-2024-42124  CVE-2024-42131  CVE-2024-42152  CVE-2024-42154  CVE-2024-42225  CVE-2024-42226  CVE-2024-42228  CVE-2024-42237  CVE-2024-42238  CVE-2024-42240  CVE-2024-42246  CVE-2024-42322  CVE-2024-43830  CVE-2024-43871  For more details about the security issue(s), including the impact, a CVSS score, acknowledgments, and other related information, refer to the CVE page(s) listed in the References section.',
    5.5, '3.1', 'CVE', '2024-05-21T15:15:16Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/errata/RHSA-2024:7000, https://access.redhat.com/errata/RHSA-2024:7001, https://access.redhat.com/security/cve/CVE-2021-47289', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2024-53190',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2024-53190', 'Medium', 'Packages', '-', 'A deadlock condition exists in the Linux kernel. During the probe of rtl8192cu, the driver ends-up performing an refuse read procedure and the read_efuse() function calls read_efuse_byte() based on the efuse size. 
            
            Mitigation for this issue is either not available or the currently available options don''t meet the Red Hat Product Security criteria comprising ease of use and deployment, applicability to widespread installation base or stability.',
    5.5, '3.1', 'CVE', '2024-12-27T14:15:26Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/security/cve/CVE-2024-53190', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2021-3655',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2021-3655', 'Low', 'Packages', '-', 'A vulnerability was found in the Linux kernel. Missing size validations on inbound SCTP packets may allow the kernel to read uninitialized memory. 
            
            As the SCTP module will be auto-loaded when required, its use can be disabled  by preventing the module from loading with the following instructions:

# echo "install sctp /bin/true" >> /etc/modprobe.d/disable-sctp.conf

The system will need to be restarted if the SCTP modules are loaded. In most circumstances, the SCTP kernel modules will be unable to be unloaded while any network interfaces are active and the protocol is in use.

If the system requires this module to work correctly, this mitigation may not be suitable.

If you need further assistance, see KCS article https://access.redhat.com/solutions/41278 or contact Red Hat Global Support Services.',
    3.3, '3.1', 'CVE', '2021-08-05T21:15:13Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/security/cve/CVE-2021-3655', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2023-53202',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2023-53202', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

PM: domains: fix memory leak with using debugfs_lookup()

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.',
    5.5, '3.1', 'CVE', '2025-09-15T15:15:46Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/errata/RHSA-2024:3138, https://access.redhat.com/security/cve/CVE-2023-53202', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2023-53357',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2023-53357', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

md/raid10: check slab-out-of-bounds in md_bitmap_get_counter

If we write a large number to md/bitmap_set_bits, md_bitmap_checkpage()
will return -EINVAL because ''page >= bitmap->pages'', but the return value
was not checked immediately in md_bitmap_get_counter() in order to set
*blocks value and slab-out-of-bounds occurs.

Move check of ''page >= bitmap->pages'' to md_bitmap_get_counter() and
return directly if true. 
            This issue in the RAID10 bitmap handling could lead to a slab out-of-bounds access when an excessively large value is written to the md/bitmap_set_bits sysfs attribute. The problem can only be triggered locally and requires privileged access, making it a denial-of-service only.
            Mitigation for this issue is either not available or the currently available options don''t meet the Red Hat Product Security criteria comprising ease of use and deployment, applicability to widespread installation base or stability.',
    4.4, '3.1', 'CVE', '2025-09-17T15:15:39Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/security/cve/CVE-2023-53357', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2025-22125',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2025-22125', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

md/raid1,raid10: don''t ignore IO flags

If blk-wbt is enabled by default, it''s found that raid write performance
is quite bad because all IO are throttled by wbt of underlying disks,
due to flag REQ_IDLE is ignored. And turns out this behaviour exist since
blk-wbt is introduced.

Other than REQ_IDLE, other flags should not be ignored as well, for
example REQ_META can be set for filesystems, clearing it can cause priority
reverse problems; And REQ_NOWAIT should not be cleared as well, because
io will wait instead of failing directly in underlying disks.

Fix those problems by keep IO flags from master bio.

Fises: f51d46d0e7cb ("md: add support for REQ_NOWAIT")',
    5.5, '3.1', 'CVE', '2025-04-16T15:16:06Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/security/cve/CVE-2025-22125', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2021-47492',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2021-47492', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

mm, thp: bail out early in collapse_file for writeback page

Currently collapse_file does not explicitly check PG_writeback, instead,
page_has_private and try_to_release_page are used to filter writeback
pages.  This does not work for xfs with blocksize equal to or larger
than pagesize, because in such case xfs has no page->private.

This makes collapse_file bail out early for writeback page.  Otherwise,
xfs end_page_writeback will panic as follows.

  page:fffffe00201bcc80 refcount:0 mapcount:0 mapping:ffff0003f88c86a8 index:0x0 pfn:0x84ef32
  aops:xfs_address_space_operations [xfs] ino:30000b7 dentry name:"libtest.so"
  flags: 0x57fffe0000008027(locked|referenced|uptodate|active|writeback)
  raw: 57fffe0000008027 ffff80001b48bc28 ffff80001b48bc28 ffff0003f88c86a8
  raw: 0000000000000000 0000000000000000 00000000ffffffff ffff0000c3e9a000
  page dumped because: VM_BUG_ON_PAGE(((unsigned int) page_ref_count(page) + 127u <= 127u))
  page->mem_cgroup:ffff0000c3e9a000
  ------------[ cut here ]------------
  kernel BUG at include/linux/mm.h:1212!
  Internal error: Oops - BUG: 0 [#1] SMP
  Modules linked in:
  BUG: Bad page state in process khugepaged  pfn:84ef32
   xfs(E)
  page:fffffe00201bcc80 refcount:0 mapcount:0 mapping:0 index:0x0 pfn:0x84ef32
   libcrc32c(E) rfkill(E) aes_ce_blk(E) crypto_simd(E) ...
  CPU: 25 PID: 0 Comm: swapper/25 Kdump: loaded Tainted: ...
  pstate: 60400005 (nZCv daif +PAN -UAO -TCO BTYPE=--)
  Call trace:
    end_page_writeback+0x1c0/0x214
    iomap_finish_page_writeback+0x13c/0x204
    iomap_finish_ioend+0xe8/0x19c
    iomap_writepage_end_bio+0x38/0x50
    bio_endio+0x168/0x1ec
    blk_update_request+0x278/0x3f0
    blk_mq_end_request+0x34/0x15c
    virtblk_request_done+0x38/0x74 [virtio_blk]
    blk_done_softirq+0xc4/0x110
    __do_softirq+0x128/0x38c
    __irq_exit_rcu+0x118/0x150
    irq_exit+0x1c/0x30
    __handle_domain_irq+0x8c/0xf0
    gic_handle_irq+0x84/0x108
    el1_irq+0xcc/0x180
    arch_cpu_idle+0x18/0x40
    default_idle_call+0x4c/0x1a0
    cpuidle_idle_call+0x168/0x1e0
    do_idle+0xb4/0x104
    cpu_startup_entry+0x30/0x9c
    secondary_start_kernel+0x104/0x180
  Code: d4210000 b0006161 910c8021 94013f4d (d4210000)
  ---[ end trace 4a88c6a074082f8c ]---
  Kernel panic - not syncing: Oops - BUG: Fatal exception in interrupt',
    5.5, '3.1', 'CVE', '2024-05-22T09:15:11Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/security/cve/CVE-2021-47492', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-48627',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-48627', 'Medium', 'Packages', '-', 'The kernel packages contain the Linux kernel, the core of any Linux operating system.

Security Fix(es):

* kernel: Marvin vulnerability side-channel leakage in the RSA decryption
operation (CVE-2023-6240)

* kernel: Information disclosure in vhost/vhost.c:vhost_new_msg()
(CVE-2024-0340)

* kernel: untrusted VMM can trigger int80 syscall handling (CVE-2024-25744)

* kernel: i2c: i801: Fix block process call transactions (CVE-2024-26593)

* kernel: pvrusb2: fix use after free on context disconnection (CVE-2023-52445)

* kernel: x86/fpu: Stop relying on userspace for info to fault in xsave buffer
that cause loop forever (CVE-2024-26603)

* kernel: use after free in i2c (CVE-2019-25162)

* kernel: i2c: validate user data in compat ioctl (CVE-2021-46934)

* kernel: media: dvbdev: Fix memory leak in dvb_media_device_free()
(CVE-2020-36777)

* kernel: usb: hub: Guard against accesses to uninitialized BOS descriptors
(CVE-2023-52477)

* kernel: mtd: require write permissions for locking and badblock ioctls
(CVE-2021-47055)

* kernel: net/smc: fix illegal rmb_desc access in SMC-D connection dump
(CVE-2024-26615)

* kernel: vt: fix memory overlapping when deleting chars in the buffer
(CVE-2022-48627)

* kernel: Integer Overflow in raid5_cache_count (CVE-2024-23307)

* kernel: media: uvcvideo: out-of-bounds read in uvc_query_v4l2_menu()
(CVE-2023-52565)

* kernel: net: bridge: data races indata-races in br_handle_frame_finish()
(CVE-2023-52578)

* kernel: net: usb: smsc75xx: Fix uninit-value access in __smsc75xx_read_reg
(CVE-2023-52528)

* kernel: platform/x86: think-lmi: Fix reference leak (CVE-2023-52520)

* kernel: RDMA/siw: Fix connection failure handling (CVE-2023-52513)

* kernel: pid: take a reference when initializing `cad_pid` (CVE-2021-47118)

* kernel: net/sched: act_ct: fix skb leak and crash on ooo frags
(CVE-2023-52610)

* kernel: netfilter: nf_tables: mark set as dead when unbinding anonymous set
with timeout (CVE-2024-26643)

* kernel: netfilter: nf_tables: disallow anonymous set with timeout flag
(CVE-2024-26642)

* kernel: i2c: i801: Don&#39;t generate an interrupt on bus reset
(CVE-2021-47153)

* kernel: xhci: handle isoc Babble and Buffer Overrun events properly
(CVE-2024-26659)

* kernel: hwmon: (coretemp) Fix out-of-bounds memory access (CVE-2024-26664)

* kernel: wifi: mac80211: fix race condition on enabling fast-xmit
(CVE-2024-26779)

* kernel: RDMA/srpt: Support specifying the srpt_service_guid parameter
(CVE-2024-26744)

* kernel: RDMA/qedr: Fix qedr_create_user_qp error flow (CVE-2024-26743)

* kernel: tty: tty_buffer: Fix the softlockup issue in flush_to_ldisc
(CVE-2021-47185)

* kernel: do_sys_name_to_handle(): use kzalloc() to fix kernel-infoleak
(CVE-2024-26901)

* kernel: RDMA/srpt: Do not register event handler until srpt device is fully
setup (CVE-2024-26872)

* kernel: usb: ulpi: Fix debugfs directory leak (CVE-2024-26919)

* kernel: usb: xhci: Add error handling in xhci_map_urb_for_dma (CVE-2024-26964)

* kernel: USB: core: Fix deadlock in usb_deauthorize_interface()
(CVE-2024-26934)

* kernel: USB: core: Fix deadlock in port &#34;disable&#34; sysfs attribute
(CVE-2024-26933)

* kernel: fs: sysfs: Fix reference leak in sysfs_break_active_protection()
(CVE-2024-26993)

* kernel: fat: fix uninitialized field in nostale filehandles (CVE-2024-26973)

* kernel: USB: usb-storage: Prevent divide-by-0 error in isd200_ata_command
(CVE-2024-27059)

* kernel: net:emac/emac-mac: Fix a use after free in emac_mac_tx_buf_send (CVE-2021-47013)

* kernel: net: usb: fix memory leak in smsc75xx_bind (CVE-2021-47171)

* kernel: powerpc/pseries: Fix potential memleak in papr_get_attr() (CVE-2022-48669)

* kernel: uio: Fix use-after-free in uio_open (CVE-2023-52439)

* kernel: wifi: ath9k: Fix potential array-index-out-of-bounds read in ath9k_htc_txstatus() (CVE-2023-52594)

* kernel: wifi: rt2x00: restart beacon queue when hardware reset (CVE-2023-52595)',
    4.4, '3.1', 'CVE', '2024-03-02T22:15:46Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/errata/RHSA-2024:3618, https://access.redhat.com/errata/RHSA-2024:3627, https://access.redhat.com/security/cve/CVE-2022-48627', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2021-4083',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2021-4083', 'High', 'Packages', '-', 'The kernel packages contain the Linux kernel, the core of any Linux operating system.

Security Fix(es):

* kernel: fget: check that the fd still exists after getting a ref to it (CVE-2021-4083)

* kernel: avoid cyclic entity chains due to malformed USB descriptors (CVE-2020-0404)

* kernel: speculation on incompletely validated data on IBM Power9 (CVE-2020-4788)

* kernel: integer overflow in k_ascii() in drivers/tty/vt/keyboard.c (CVE-2020-13974)

* kernel: out-of-bounds read in bpf_skb_change_head() of filter.c due to a use-after-free (CVE-2021-0941)

* kernel: joydev: zero size passed to joydev_handle_JSIOCSBTNMAP() (CVE-2021-3612)

* kernel: reading /proc/sysvipc/shm does not scale with large shared memory segment counts (CVE-2021-3669)

* kernel: out-of-bound Read in qrtr_endpoint_post in net/qrtr/qrtr.c (CVE-2021-3743)

* kernel: crypto: ccp - fix resource leaks in ccp_run_aes_gcm_cmd() (CVE-2021-3744)

* kernel: possible use-after-free in bluetooth module (CVE-2021-3752)

* kernel: unaccounted ipc objects in Linux kernel lead to breaking memcg limits and DoS attacks (CVE-2021-3759)

* kernel: DoS in ccp_run_aes_gcm_cmd() function (CVE-2021-3764)

* kernel: sctp: Invalid chunks may be used to remotely remove existing associations (CVE-2021-3772)

* kernel: lack of port sanity checking in natd and netfilter leads to exploit of OpenVPN clients (CVE-2021-3773)

* kernel: possible leak or coruption of data residing on hugetlbfs (CVE-2021-4002)

* kernel: security regression for CVE-2018-13405 (CVE-2021-4037)

* kernel: Buffer overwrite in decode_nfs_fh function (CVE-2021-4157)

* kernel: cgroup: Use open-time creds and namespace for migration perm checks (CVE-2021-4197)

* kernel: Race condition in races in sk_peer_pid and sk_peer_cred accesses (CVE-2021-4203)

* kernel: new DNS Cache Poisoning Attack based on ICMP fragment needed packets replies (CVE-2021-20322)

* kernel: arm: SIGPAGE information disclosure vulnerability (CVE-2021-21781)

* hw: cpu: LFENCE/JMP Mitigation Update for CVE-2017-5715 (CVE-2021-26401)

* kernel: Local privilege escalation due to incorrect BPF JIT branch displacement computation (CVE-2021-29154)

* kernel: use-after-free in hso_free_net_device() in drivers/net/usb/hso.c (CVE-2021-37159)

* kernel: eBPF multiplication integer overflow in prealloc_elems_and_freelist() in kernel/bpf/stackmap.c leads to out-of-bounds write (CVE-2021-41864)

* kernel: Heap buffer overflow in firedtv driver (CVE-2021-42739)

* kernel: ppc: kvm: allows a malicious KVM guest to crash the host (CVE-2021-43056)

* kernel: an array-index-out-bounds in detach_capi_ctr in drivers/isdn/capi/kcapi.c (CVE-2021-43389)

* kernel: mwifiex_usb_recv() in drivers/net/wireless/marvell/mwifiex/usb.c allows an attacker to cause DoS via crafted USB device (CVE-2021-43976)

* kernel: use-after-free in the TEE subsystem (CVE-2021-44733)

* kernel: information leak in the IPv6 implementation (CVE-2021-45485)

* kernel: information leak in the IPv4 implementation (CVE-2021-45486)

* hw: cpu: intel: Branch History Injection (BHI) (CVE-2022-0001)

* hw: cpu: intel: Intra-Mode BTI (CVE-2022-0002)

* kernel: Local denial of service in bond_ipsec_add_sa (CVE-2022-0286)

* kernel: DoS in sctp_addto_chunk in net/sctp/sm_make_chunk.c (CVE-2022-0322)

* kernel: FUSE allows UAF reads of write() buffers, allowing theft of (partial) /etc/shadow hashes (CVE-2022-1011)

* kernel: use-after-free in nouveau kernel module (CVE-2020-27820)

For more details about the security issue(s), including the impact, a CVSS score, acknowledgments, and other related information, refer to the CVE page(s) listed in the References section.

Additional Changes:

For detailed information on changes in this release, see the Red Hat Enterprise Linux 8.6 Release Notes linked from the References section.',
    7.4, '3.1', 'CVE', '2022-01-18T17:15:09Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/errata/RHSA-2022:1975, https://access.redhat.com/errata/RHSA-2022:1988, https://access.redhat.com/security/cve/CVE-2021-4083', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2025-37913',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2025-37913', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

net_sched: qfq: Fix double list add in class with netem as child qdisc

As described in Gerrard''s report [1], there are use cases where a netem
child qdisc will make the parent qdisc''s enqueue callback reentrant.
In the case of qfq, there won''t be a UAF, but the code will add the same
classifier to the list twice, which will cause memory corruption.

This patch checks whether the class was already added to the agg->active
list (cl_is_active) before doing the addition to cater for the reentrant
case.

[1] https://lore.kernel.org/netdev/CAHcdcOm+03OD2j6R0=YHKqmy=VgJ8xEOKuP6c7mSgnp-TEJJbw@mail.gmail.com/',
    6.3, '3.1', 'CVE', '2025-05-20T16:15:27Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/security/cve/CVE-2025-37913', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2021-47498',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2021-47498', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

dm rq: don''t queue request to blk-mq during DM suspend

DM uses blk-mq''s quiesce/unquiesce to stop/start device mapper queue.

But blk-mq''s unquiesce may come from outside events, such as elevator
switch, updating nr_requests or others, and request may come during
suspend, so simply ask for blk-mq to requeue it.

Fixes one kernel panic issue when running updating nr_requests and
dm-mpath suspend/resume stress test. 
            This issue is fixed in RHEL-8.6 and above (including 8.10):
~~~
in (rhel-8.6, rhel-8.7, rhel-8.8, rhel-8.9, rhel-8.10) dm rq: don''t queue request to blk-mq during DM suspend
~~~',
    5.5, '3.1', 'CVE', '2024-05-22T09:15:11Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/errata/RHSA-2022:1988, https://access.redhat.com/security/cve/CVE-2021-47498', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-50577',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-50577', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

ima: Fix memory leak in __ima_inode_hash()

Commit f3cc6b25dcc5 ("ima: always measure and audit files in policy") lets
measurement or audit happen even if the file digest cannot be calculated.

As a result, iint->ima_hash could have been allocated despite
ima_collect_measurement() returning an error.

Since ima_hash belongs to a temporary inode metadata structure, declared
at the beginning of __ima_inode_hash(), just add a kfree() call if
ima_collect_measurement() returns an error different from -ENOMEM (in that
case, ima_hash should not have been allocated).',
    5.5, '3.1', 'CVE', '2000-01-01T00:00:00Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/security/cve/CVE-2022-50577', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2024-26974',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2024-26974', 'Medium', 'Packages', '-', 'The kernel packages contain the Linux kernel, the core of any Linux operating system.

Security Fix(es):

* kernel: Bluetooth BR/EDR PIN Pairing procedure is vulnerable to an impersonation attack (CVE-2020-26555)

* kernel: TCP-spoofed ghost ACKs and leak leak initial sequence number (CVE-2023-52881,RHV-2024-1001)

* kernel: ovl: fix leaked entry (CVE-2021-46972)

* kernel: platform/x86: dell-smbios-wmi: Fix oops on rmmod dell_smbios (CVE-2021-47073)

* kernel: gro: fix ownership transfer (CVE-2024-35890)

* kernel: tls: (CVE-2024-26584, CVE-2024-26583, CVE-2024-26585)

* kernel: wifi: (CVE-2024-35789, CVE-2024-27410, CVE-2024-35838, CVE-2024-35845)

* kernel: mlxsw: (CVE-2024-35855, CVE-2024-35854, CVE-2024-35853, CVE-2024-35852, CVE-2024-36007)

* kernel: PCI interrupt mapping cause oops [rhel-8] (CVE-2021-46909)

* kernel: ipc/mqueue, msg, sem: avoid relying on a stack reference past its expiry (CVE-2021-47069)

* kernel: hwrng: core - Fix page fault dead lock on mmap-ed hwrng [rhel-8] (CVE-2023-52615)

* kernel: net/mlx5e: (CVE-2023-52626, CVE-2024-35835, CVE-2023-52667, CVE-2024-35959)

* kernel: drm/amdgpu: use-after-free vulnerability (CVE-2024-26656)

* kernel: Bluetooth: Avoid potential use-after-free in hci_error_reset [rhel-8] (CVE-2024-26801)

* kernel: Squashfs: check the inode number is not the invalid value of zero (CVE-2024-26982)

* kernel: netfilter: nf_tables: use timestamp to check for set element timeout [rhel-8.10] (CVE-2024-27397)

* kernel: mm/damon/vaddr-test: memory leak in damon_do_test_apply_three_regions() (CVE-2023-52560)

* kernel: ppp_async: limit MRU to 64K (CVE-2024-26675)

* kernel: x86/mm/swap: (CVE-2024-26759, CVE-2024-26906)

* kernel: tipc: fix kernel warning when sending SYN message [rhel-8] (CVE-2023-52700)

* kernel: RDMA/mlx5: Fix fortify source warning while accessing Eth segment (CVE-2024-26907)

* kernel: erspan: make sure erspan_base_hdr is present in skb-&gt;head (CVE-2024-35888)

* kernel: powerpc/imc-pmu/powernv: (CVE-2023-52675, CVE-2023-52686)

* kernel: KVM: SVM: improper check in svm_set_x2apic_msr_interception allows direct access to host x2apic msrs (CVE-2023-5090)

* kernel: EDAC/thunderx: Incorrect buffer size in drivers/edac/thunderx_edac.c (CVE-2023-52464)

* kernel: ipv6: sr: fix possible use-after-free and null-ptr-deref (CVE-2024-26735)

* kernel: mptcp: fix data re-injection from stale subflow (CVE-2024-26826)

* kernel: crypto: (CVE-2024-26974, CVE-2023-52669, CVE-2023-52813)

* kernel: net/mlx5/bnx2x/usb: (CVE-2024-35960, CVE-2024-35958, CVE-2021-47310, CVE-2024-26804, CVE-2021-47311, CVE-2024-26859, CVE-2021-47236, CVE-2023-52703)

* kernel: i40e: Do not use WQ_MEM_RECLAIM flag for workqueue (CVE-2024-36004)

* kernel: perf/core: Bail out early if the request AUX area is out of bound (CVE-2023-52835)

* kernel: USB/usbnet: (CVE-2023-52781, CVE-2023-52877, CVE-2021-47495)

* kernel: can: (CVE-2023-52878, CVE-2021-47456)

* kernel: mISDN: fix possible use-after-free in HFC_cleanup() (CVE-2021-47356)

* kernel: udf: Fix NULL pointer dereference in udf_symlink function (CVE-2021-47353)

Bug Fix(es):

* Kernel panic - kernel BUG at mm/slub.c:376! (JIRA:RHEL-29783)

* Temporary values in FIPS integrity test should be zeroized [rhel-8.10.z] (JIRA:RHEL-35361)

* RHEL8.6 - kernel: s390/cpum_cf: make crypto counters upward compatible (JIRA:RHEL-36048)

* [RHEL8] blktests block/024 failed (JIRA:RHEL-8130)

* RHEL8.9: EEH injections results  Error:  Power fault on Port 0 and other call traces(Everest/1050/Shiner) (JIRA:RHEL-14195)

* Latency spikes with Matrox G200 graphic cards (JIRA:RHEL-36172)

For more details about the security issue(s), including the impact, a CVSS score, acknowledgments, and other related information, refer to the CVE page(s) listed in the References section.',
    5.8, '3.1', 'CVE', '2024-05-01T06:15:14Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/errata/RHSA-2024:4211, https://access.redhat.com/errata/RHSA-2024:4352, https://access.redhat.com/security/cve/CVE-2024-26974', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2024-50192',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2024-50192', 'Medium', 'Packages', '-', 'The kernel packages contain the Linux kernel, the core of any Linux operating system.

Security Fix(es):

* kernel: selinux,smack: don''t bypass permissions check in inode_setsecctx hook (CVE-2024-46695)

* kernel: net: avoid potential underflow in qdisc_pkt_len_init() with UFO (CVE-2024-49949)

* kernel: blk-rq-qos: fix crash on rq_qos_wait vs. rq_qos_wake_function race (CVE-2024-50082)

* kernel: arm64: probes: Remove broken LDR (literal) uprobe support (CVE-2024-50099)

* kernel: xfrm: fix one more kernel-infoleak in algo dumping (CVE-2024-50110)

* kernel: xfrm: validate new SA&#39;s prefixlen using SA family when sel.family is unset (CVE-2024-50142)

* kernel: irqchip/gic-v4: Don''t allow a VMOVP on a dying VPE (CVE-2024-50192)

* kernel: netfilter: nf_reject_ipv6: fix potential crash in nf_send_reset6() (CVE-2024-50256)

* kernel: vsock/virtio: Initialization of the dangling pointer occurring in vsk->trans (CVE-2024-50264)

For more details about the security issue(s), including the impact, a CVSS score, acknowledgments, and other related information, refer to the CVE page(s) listed in the References section.',
    4.7, '3.1', 'CVE', '2024-11-08T06:15:16Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/errata/RHSA-2024:10943, https://access.redhat.com/errata/RHSA-2024:10944, https://access.redhat.com/security/cve/CVE-2024-50192', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2023-2269',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2023-2269', 'Medium', 'Packages', '-', 'The kernel packages contain the Linux kernel, the core of any Linux operating system.

Security Fix(es):

* kernel: tun: avoid double free in tun_free_netdev (CVE-2022-4744)

* kernel: net/sched: multiple vulnerabilities (CVE-2023-3609, CVE-2023-3611, CVE-2023-4128, CVE-2023-4206, CVE-2023-4207, CVE-2023-4208)

* kernel: out-of-bounds write in qfq_change_class function (CVE-2023-31436)

* kernel: out-of-bounds write in hw_atl_utils_fw_rpc_wait (CVE-2021-43975)

* kernel: Rate limit overflow messages in r8152 in intr_callback (CVE-2022-3594)

* kernel: use after free flaw in l2cap_conn_del (CVE-2022-3640)

* kernel: double free in usb_8dev_start_xmit (CVE-2022-28388)

* kernel: vmwgfx: multiple vulnerabilities (CVE-2022-38457, CVE-2022-40133, CVE-2023-33951, CVE-2023-33952)

* hw: Intel: Gather Data Sampling (GDS) side channel vulnerability (CVE-2022-40982)

* kernel: Information leak in l2cap_parse_conf_req (CVE-2022-42895)

* kernel: KVM: multiple vulnerabilities (CVE-2022-45869, CVE-2023-4155, CVE-2023-30456)

* kernel: memory leak in ttusb_dec_exit_dvb (CVE-2022-45887)

* kernel: speculative pointer dereference in do_prlimit (CVE-2023-0458)

* kernel: use-after-free due to race condition in qdisc_graft (CVE-2023-0590)

* kernel: x86/mm: Randomize per-cpu entry area (CVE-2023-0597)

* kernel: HID: check empty report_list in hid_validate_values (CVE-2023-1073)

* kernel: sctp: fail if no bound addresses can be used for a given scope (CVE-2023-1074)

* kernel: hid: Use After Free in asus_remove (CVE-2023-1079)

* kernel: use-after-free in drivers/media/rc/ene_ir.c (CVE-2023-1118)

* kernel: hash collisions in the IPv6 connection lookup table (CVE-2023-1206)

* kernel: ovl: fix use after free in struct ovl_aio_req (CVE-2023-1252)

* kernel: denial of service in tipc_conn_close (CVE-2023-1382)

* kernel: Use after free bug in btsdio_remove due to race condition (CVE-2023-1989)

* kernel: Spectre v2 SMT mitigations problem (CVE-2023-1998)

* kernel: ext4: use-after-free in ext4_xattr_set_entry (CVE-2023-2513)

* kernel: fbcon: shift-out-of-bounds in fbcon_set_font (CVE-2023-3161)

* kernel: out-of-bounds access in relay_file_read (CVE-2023-3268)

* kernel: xfrm: NULL pointer dereference in xfrm_update_ae_params (CVE-2023-3772)

* kernel: smsusb: use-after-free caused by do_submit_urb (CVE-2023-4132)

* kernel: Race between task migrating pages and another task calling exit_mmap (CVE-2023-4732)

* Kernel: denial of service in atm_tc_enqueue due to type confusion (CVE-2023-23455)

* kernel: mpls: double free on sysctl allocation failure (CVE-2023-26545)

* kernel: Denial of service issue in az6027 driver (CVE-2023-28328)

* kernel: lib/seq_buf.c has a seq_buf_putmem_hex buffer overflow (CVE-2023-28772)

* kernel: blocking operation in dvb_frontend_get_event and wait_event_interruptible (CVE-2023-31084)

* kernel: net: qcom/emac: race condition leading to use-after-free in emac_remove (CVE-2023-33203)

* kernel: saa7134: race condition leading to use-after-free in saa7134_finidev (CVE-2023-35823)

* kernel: dm1105: race condition leading to use-after-free in dm1105_remove.c (CVE-2023-35824)

* kernel: r592: race condition leading to use-after-free in r592_remove (CVE-2023-35825)

* kernel: net/tls: tls_is_tx_ready() checked list_entry (CVE-2023-1075)

* kernel: use-after-free bug in remove function xgene_hwmon_remove (CVE-2023-1855)

* kernel: Use after free bug in r592_remove (CVE-2023-3141)

* kernel: gfs2: NULL pointer dereference in gfs2_evict_inode (CVE-2023-3212)

For more details about the security issue(s), including the impact, a CVSS score, acknowledgments, and other related information, refer to the CVE page(s) listed in the References section.

Additional Changes:

For detailed information on changes in this release, see the Red Hat Enterprise Linux 8.9 Release Notes linked from the References section.',
    4.4, '3.1', 'CVE', '2023-04-25T21:15:10Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/errata/RHSA-2023:6901, https://access.redhat.com/errata/RHSA-2023:7077, https://access.redhat.com/security/cve/CVE-2023-2269', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2021-47495',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2021-47495', 'Medium', 'Packages', '-', 'The kernel packages contain the Linux kernel, the core of any Linux operating system.

Security Fix(es):

* kernel: Bluetooth BR/EDR PIN Pairing procedure is vulnerable to an impersonation attack (CVE-2020-26555)

* kernel: TCP-spoofed ghost ACKs and leak leak initial sequence number (CVE-2023-52881,RHV-2024-1001)

* kernel: ovl: fix leaked entry (CVE-2021-46972)

* kernel: platform/x86: dell-smbios-wmi: Fix oops on rmmod dell_smbios (CVE-2021-47073)

* kernel: gro: fix ownership transfer (CVE-2024-35890)

* kernel: tls: (CVE-2024-26584, CVE-2024-26583, CVE-2024-26585)

* kernel: wifi: (CVE-2024-35789, CVE-2024-27410, CVE-2024-35838, CVE-2024-35845)

* kernel: mlxsw: (CVE-2024-35855, CVE-2024-35854, CVE-2024-35853, CVE-2024-35852, CVE-2024-36007)

* kernel: PCI interrupt mapping cause oops [rhel-8] (CVE-2021-46909)

* kernel: ipc/mqueue, msg, sem: avoid relying on a stack reference past its expiry (CVE-2021-47069)

* kernel: hwrng: core - Fix page fault dead lock on mmap-ed hwrng [rhel-8] (CVE-2023-52615)

* kernel: net/mlx5e: (CVE-2023-52626, CVE-2024-35835, CVE-2023-52667, CVE-2024-35959)

* kernel: drm/amdgpu: use-after-free vulnerability (CVE-2024-26656)

* kernel: Bluetooth: Avoid potential use-after-free in hci_error_reset [rhel-8] (CVE-2024-26801)

* kernel: Squashfs: check the inode number is not the invalid value of zero (CVE-2024-26982)

* kernel: netfilter: nf_tables: use timestamp to check for set element timeout [rhel-8.10] (CVE-2024-27397)

* kernel: mm/damon/vaddr-test: memory leak in damon_do_test_apply_three_regions() (CVE-2023-52560)

* kernel: ppp_async: limit MRU to 64K (CVE-2024-26675)

* kernel: x86/mm/swap: (CVE-2024-26759, CVE-2024-26906)

* kernel: tipc: fix kernel warning when sending SYN message [rhel-8] (CVE-2023-52700)

* kernel: RDMA/mlx5: Fix fortify source warning while accessing Eth segment (CVE-2024-26907)

* kernel: erspan: make sure erspan_base_hdr is present in skb-&gt;head (CVE-2024-35888)

* kernel: powerpc/imc-pmu/powernv: (CVE-2023-52675, CVE-2023-52686)

* kernel: KVM: SVM: improper check in svm_set_x2apic_msr_interception allows direct access to host x2apic msrs (CVE-2023-5090)

* kernel: EDAC/thunderx: Incorrect buffer size in drivers/edac/thunderx_edac.c (CVE-2023-52464)

* kernel: ipv6: sr: fix possible use-after-free and null-ptr-deref (CVE-2024-26735)

* kernel: mptcp: fix data re-injection from stale subflow (CVE-2024-26826)

* kernel: crypto: (CVE-2024-26974, CVE-2023-52669, CVE-2023-52813)

* kernel: net/mlx5/bnx2x/usb: (CVE-2024-35960, CVE-2024-35958, CVE-2021-47310, CVE-2024-26804, CVE-2021-47311, CVE-2024-26859, CVE-2021-47236, CVE-2023-52703)

* kernel: i40e: Do not use WQ_MEM_RECLAIM flag for workqueue (CVE-2024-36004)

* kernel: perf/core: Bail out early if the request AUX area is out of bound (CVE-2023-52835)

* kernel: USB/usbnet: (CVE-2023-52781, CVE-2023-52877, CVE-2021-47495)

* kernel: can: (CVE-2023-52878, CVE-2021-47456)

* kernel: mISDN: fix possible use-after-free in HFC_cleanup() (CVE-2021-47356)

* kernel: udf: Fix NULL pointer dereference in udf_symlink function (CVE-2021-47353)

Bug Fix(es):

* Kernel panic - kernel BUG at mm/slub.c:376! (JIRA:RHEL-29783)

* Temporary values in FIPS integrity test should be zeroized [rhel-8.10.z] (JIRA:RHEL-35361)

* RHEL8.6 - kernel: s390/cpum_cf: make crypto counters upward compatible (JIRA:RHEL-36048)

* [RHEL8] blktests block/024 failed (JIRA:RHEL-8130)

* RHEL8.9: EEH injections results  Error:  Power fault on Port 0 and other call traces(Everest/1050/Shiner) (JIRA:RHEL-14195)

* Latency spikes with Matrox G200 graphic cards (JIRA:RHEL-36172)

For more details about the security issue(s), including the impact, a CVSS score, acknowledgments, and other related information, refer to the CVE page(s) listed in the References section.',
    4.4, '3.1', 'CVE', '2024-05-22T09:15:11Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/errata/RHSA-2024:4211, https://access.redhat.com/errata/RHSA-2024:4352, https://access.redhat.com/security/cve/CVE-2021-47495', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2023-35823',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2023-35823', 'Medium', 'Packages', '-', 'The kernel packages contain the Linux kernel, the core of any Linux operating system.

Security Fix(es):

* kernel: tun: avoid double free in tun_free_netdev (CVE-2022-4744)

* kernel: net/sched: multiple vulnerabilities (CVE-2023-3609, CVE-2023-3611, CVE-2023-4128, CVE-2023-4206, CVE-2023-4207, CVE-2023-4208)

* kernel: out-of-bounds write in qfq_change_class function (CVE-2023-31436)

* kernel: out-of-bounds write in hw_atl_utils_fw_rpc_wait (CVE-2021-43975)

* kernel: Rate limit overflow messages in r8152 in intr_callback (CVE-2022-3594)

* kernel: use after free flaw in l2cap_conn_del (CVE-2022-3640)

* kernel: double free in usb_8dev_start_xmit (CVE-2022-28388)

* kernel: vmwgfx: multiple vulnerabilities (CVE-2022-38457, CVE-2022-40133, CVE-2023-33951, CVE-2023-33952)

* hw: Intel: Gather Data Sampling (GDS) side channel vulnerability (CVE-2022-40982)

* kernel: Information leak in l2cap_parse_conf_req (CVE-2022-42895)

* kernel: KVM: multiple vulnerabilities (CVE-2022-45869, CVE-2023-4155, CVE-2023-30456)

* kernel: memory leak in ttusb_dec_exit_dvb (CVE-2022-45887)

* kernel: speculative pointer dereference in do_prlimit (CVE-2023-0458)

* kernel: use-after-free due to race condition in qdisc_graft (CVE-2023-0590)

* kernel: x86/mm: Randomize per-cpu entry area (CVE-2023-0597)

* kernel: HID: check empty report_list in hid_validate_values (CVE-2023-1073)

* kernel: sctp: fail if no bound addresses can be used for a given scope (CVE-2023-1074)

* kernel: hid: Use After Free in asus_remove (CVE-2023-1079)

* kernel: use-after-free in drivers/media/rc/ene_ir.c (CVE-2023-1118)

* kernel: hash collisions in the IPv6 connection lookup table (CVE-2023-1206)

* kernel: ovl: fix use after free in struct ovl_aio_req (CVE-2023-1252)

* kernel: denial of service in tipc_conn_close (CVE-2023-1382)

* kernel: Use after free bug in btsdio_remove due to race condition (CVE-2023-1989)

* kernel: Spectre v2 SMT mitigations problem (CVE-2023-1998)

* kernel: ext4: use-after-free in ext4_xattr_set_entry (CVE-2023-2513)

* kernel: fbcon: shift-out-of-bounds in fbcon_set_font (CVE-2023-3161)

* kernel: out-of-bounds access in relay_file_read (CVE-2023-3268)

* kernel: xfrm: NULL pointer dereference in xfrm_update_ae_params (CVE-2023-3772)

* kernel: smsusb: use-after-free caused by do_submit_urb (CVE-2023-4132)

* kernel: Race between task migrating pages and another task calling exit_mmap (CVE-2023-4732)

* Kernel: denial of service in atm_tc_enqueue due to type confusion (CVE-2023-23455)

* kernel: mpls: double free on sysctl allocation failure (CVE-2023-26545)

* kernel: Denial of service issue in az6027 driver (CVE-2023-28328)

* kernel: lib/seq_buf.c has a seq_buf_putmem_hex buffer overflow (CVE-2023-28772)

* kernel: blocking operation in dvb_frontend_get_event and wait_event_interruptible (CVE-2023-31084)

* kernel: net: qcom/emac: race condition leading to use-after-free in emac_remove (CVE-2023-33203)

* kernel: saa7134: race condition leading to use-after-free in saa7134_finidev (CVE-2023-35823)

* kernel: dm1105: race condition leading to use-after-free in dm1105_remove.c (CVE-2023-35824)

* kernel: r592: race condition leading to use-after-free in r592_remove (CVE-2023-35825)

* kernel: net/tls: tls_is_tx_ready() checked list_entry (CVE-2023-1075)

* kernel: use-after-free bug in remove function xgene_hwmon_remove (CVE-2023-1855)

* kernel: Use after free bug in r592_remove (CVE-2023-3141)

* kernel: gfs2: NULL pointer dereference in gfs2_evict_inode (CVE-2023-3212)

For more details about the security issue(s), including the impact, a CVSS score, acknowledgments, and other related information, refer to the CVE page(s) listed in the References section.

Additional Changes:

For detailed information on changes in this release, see the Red Hat Enterprise Linux 8.9 Release Notes linked from the References section.',
    6.7, '3.1', 'CVE', '2023-06-18T22:15:09Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/errata/RHSA-2023:6901, https://access.redhat.com/errata/RHSA-2023:7077, https://access.redhat.com/security/cve/CVE-2023-35823', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2021-47497',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2021-47497', 'Medium', 'Packages', '-', 'The kernel packages contain the Linux kernel, the core of any Linux operating system.  
Security Fix(es):

 CVE-2023-6040  CVE-2024-26595  CVE-2024-26600  CVE-2021-46984  CVE-2023-52478  CVE-2023-52476  CVE-2023-52522  CVE-2021-47101  CVE-2021-47097  CVE-2023-52605  CVE-2024-26638  CVE-2024-26645  CVE-2024-26665  CVE-2024-26720  CVE-2024-26717  CVE-2024-26769  CVE-2024-26846  CVE-2024-26894  CVE-2024-26880  CVE-2024-26855  CVE-2024-26923  CVE-2024-26939  CVE-2024-27013  CVE-2024-27042  CVE-2024-35809  CVE-2023-52683  CVE-2024-35884  CVE-2024-35877  CVE-2024-35944  CVE-2024-35989  CVE-2021-47412  CVE-2021-47393  CVE-2021-47386  CVE-2021-47385  CVE-2021-47384  CVE-2021-47383  CVE-2021-47432  CVE-2021-47352  CVE-2021-47338  CVE-2021-47321  CVE-2021-47289  CVE-2021-47287  CVE-2023-52798  CVE-2023-52809  CVE-2023-52817  CVE-2023-52840  CVE-2023-52800  CVE-2021-47441  CVE-2021-47466  CVE-2021-47455  CVE-2021-47497  CVE-2021-47560  CVE-2021-47527  CVE-2024-36883  CVE-2024-36922  CVE-2024-36920  CVE-2024-36902  CVE-2024-36953  CVE-2024-36939  CVE-2024-36919  CVE-2024-36901  CVE-2021-47582  CVE-2021-47609  CVE-2024-38619  CVE-2022-48754  CVE-2022-48760  CVE-2024-38581  CVE-2024-38579  CVE-2024-38570  CVE-2024-38559  CVE-2024-38558  CVE-2024-37356  CVE-2024-39471  CVE-2024-39499  CVE-2024-39501  CVE-2024-39506  CVE-2024-40904  CVE-2024-40911  CVE-2024-40912  CVE-2024-40929  CVE-2024-40931  CVE-2024-40941  CVE-2024-40954  CVE-2024-40958  CVE-2024-40959  CVE-2024-40960  CVE-2024-40972  CVE-2024-40977  CVE-2024-40978  CVE-2024-40988  CVE-2024-40989  CVE-2024-40995  CVE-2024-40997  CVE-2024-40998  CVE-2024-41005  CVE-2024-40901  CVE-2024-41007  CVE-2024-41008  CVE-2022-48804  CVE-2022-48836  CVE-2022-48866  CVE-2024-41090  CVE-2024-41091  CVE-2024-41012  CVE-2024-41013  CVE-2024-41014  CVE-2024-41023  CVE-2024-41035  CVE-2024-41038  CVE-2024-41039  CVE-2024-41040  CVE-2024-41041  CVE-2024-41044  CVE-2024-41055  CVE-2024-41056  CVE-2024-41060  CVE-2024-41064  CVE-2024-41065  CVE-2024-41071  CVE-2024-41076  CVE-2024-41097  CVE-2024-42084  CVE-2024-42090  CVE-2024-42094  CVE-2024-42096  CVE-2024-42114  CVE-2024-42124  CVE-2024-42131  CVE-2024-42152  CVE-2024-42154  CVE-2024-42225  CVE-2024-42226  CVE-2024-42228  CVE-2024-42237  CVE-2024-42238  CVE-2024-42240  CVE-2024-42246  CVE-2024-42322  CVE-2024-43830  CVE-2024-43871  For more details about the security issue(s), including the impact, a CVSS score, acknowledgments, and other related information, refer to the CVE page(s) listed in the References section.',
    4.4, '3.1', 'CVE', '2024-05-22T09:15:11Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/errata/RHSA-2024:7000, https://access.redhat.com/errata/RHSA-2024:7001, https://access.redhat.com/security/cve/CVE-2021-47497', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2025-37995',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2025-37995', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

module: ensure that kobject_put() is safe for module type kobjects

In ''lookup_or_create_module_kobject()'', an internal kobject is created
using ''module_ktype''. So call to ''kobject_put()'' on error handling
path causes an attempt to use an uninitialized completion pointer in
''module_kobject_release()''. In this scenario, we just want to release
kobject without an extra synchronization required for a regular module
unloading process, so adding an extra check whether ''complete()'' is
actually required makes ''kobject_put()'' safe.',
    5.1, '3.1', 'CVE', '2025-05-29T14:15:36Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/security/cve/CVE-2025-37995', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2023-53220',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2023-53220', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

media: az6007: Fix null-ptr-deref in az6007_i2c_xfer()

In az6007_i2c_xfer, msg is controlled by user. When msg[i].buf
is null and msg[i].len is zero, former checks on msg[i].buf would be
passed. Malicious data finally reach az6007_i2c_xfer. If accessing
msg[i].buf[0] without sanity check, null ptr deref would happen.
We add check on msg[i].len to prevent crash.

Similar commit:
commit 0ed554fd769a
("media: dvb-usb: az6027: fix null-ptr-deref in az6027_i2c_xfer()")',
    5.5, '3.1', 'CVE', '2025-09-15T15:15:48Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/security/cve/CVE-2023-53220', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2020-26146',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2020-26146', 'Medium', 'Packages', '-', 'The kernel packages contain the Linux kernel, the core of any Linux operating system.

Security Fix(es):
* kernel: out-of-bounds reads in pinctrl subsystem (CVE-2020-0427)
* kernel: Improper input validation in some Intel(R) Ethernet E810 Adapter drivers (CVE-2020-24502)
* kernel: Insufficient access control in some Intel(R) Ethernet E810 Adapter drivers (CVE-2020-24503)
* kernel: Uncontrolled resource consumption in some Intel(R) Ethernet E810 Adapter drivers (CVE-2020-24504)
* kernel: Fragmentation cache not cleared on reconnection (CVE-2020-24586)
* kernel: Reassembling fragments encrypted under different keys (CVE-2020-24587)
* kernel: wifi frame payload being parsed incorrectly as an L2 frame (CVE-2020-24588)
* kernel: Forwarding EAPOL from unauthenticated wifi client (CVE-2020-26139)
* kernel: accepting plaintext data frames in protected networks (CVE-2020-26140)
* kernel: not verifying TKIP MIC of fragmented frames (CVE-2020-26141)
* kernel: accepting fragmented plaintext frames in protected networks (CVE-2020-26143)
* kernel: accepting unencrypted A-MSDU frames that start with RFC1042 header (CVE-2020-26144)
* kernel: accepting plaintext broadcast fragments as full frames (CVE-2020-26145)
* kernel: powerpc: RTAS calls can be used to compromise kernel integrity (CVE-2020-27777)
* kernel: locking inconsistency in tty_io.c and tty_jobctrl.c can lead to a read-after-free (CVE-2020-29660)
* kernel: buffer overflow in mwifiex_cmd_802_11_ad_hoc_start function via a long SSID value (CVE-2020-36158)
* kernel: slab out-of-bounds read in hci_extended_inquiry_result_evt()  (CVE-2020-36386)
* kernel: Improper access control in BlueZ may allow information disclosure vulnerability. (CVE-2021-0129)
* kernel: Use-after-free in ndb_queue_rq() in drivers/block/nbd.c (CVE-2021-3348)
* kernel: Linux kernel eBPF RINGBUF map oversized allocation (CVE-2021-3489)
* kernel: double free in bluetooth subsystem when the HCI device initialization fails (CVE-2021-3564)
* kernel: use-after-free in function hci_sock_bound_ioctl() (CVE-2021-3573)
* kernel: eBPF 32-bit source register truncation on div/mod (CVE-2021-3600)
* kernel: DoS in rb_per_cpu_empty() (CVE-2021-3679)
* kernel: Mounting overlayfs inside an unprivileged user namespace can reveal files (CVE-2021-3732)
* kernel: heap overflow in __cgroup_bpf_run_filter_getsockopt() (CVE-2021-20194)
* kernel: Race condition in sctp_destroy_sock list_del (CVE-2021-23133)
* kernel: fuse: stall on CPU can occur because a retry loop continually finds the same bad inode (CVE-2021-28950)
* kernel: System crash in intel_pmu_drain_pebs_nhm in arch/x86/events/intel/ds.c (CVE-2021-28971)
* kernel: protection can be bypassed to leak content of kernel memory (CVE-2021-29155)
* kernel: improper input validation in tipc_nl_retrieve_key function in net/tipc/node.c (CVE-2021-29646)
* kernel: lack a full memory barrier may lead to DoS (CVE-2021-29650)
* kernel: local escalation of privileges in handling of eBPF programs (CVE-2021-31440)
* kernel: protection of stack pointer against speculative pointer arithmetic can be bypassed to leak content of kernel memory (CVE-2021-31829)
* kernel: out-of-bounds reads and writes due to enforcing incorrect limits for pointer arithmetic operations by BPF verifier (CVE-2021-33200)
* kernel: reassembling encrypted fragments with non-consecutive packet numbers (CVE-2020-26146)
* kernel: reassembling mixed encrypted/plaintext fragments (CVE-2020-26147)
* kernel: the copy-on-write implementation can grant unintended write access because of a race condition in a THP mapcount check (CVE-2020-29368)
* kernel: flowtable list del corruption with kernel BUG at lib/list_debug.c:50 (CVE-2021-3635)
* kernel: NULL pointer dereference in llsec_key_alloc() in net/mac802154/llsec.c (CVE-2021-3659)
* kernel: setsockopt System Call Untrusted Pointer Dereference Information Disclosure (CVE-2021-20239)
* kernel: out of bounds array access in drivers/md/dm-ioctl.c (CVE-2021-31916)',
    5.3, '3.1', 'CVE', '2021-05-11T20:15:08Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/errata/RHSA-2021:4140, https://access.redhat.com/errata/RHSA-2021:4356, https://access.redhat.com/security/cve/CVE-2020-26146', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2020-25211',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2020-25211', 'Medium', 'Packages', '-', 'The kernel packages contain the Linux kernel, the core of any Linux operating system.

Security Fix(es):

* kernel: Local buffer overflow in ctnetlink_parse_tuple_filter in net/netfilter/nf_conntrack_netlink.c (CVE-2020-25211)

For more details about the security issue(s), including the impact, a CVSS score, acknowledgments, and other related information, refer to the CVE page(s) listed in the References section.

Bug Fix(es):

* avoid flush_backlog IPI for isolated CPUs by configuring RPS cpumask (BZ#1883314)

* rngd consumes 100% cpu on rhel-8.3 system in fips mode (BZ#1886192)

* RHEL8.1 - Random memory corruption may occur due to incorrect tlbflush (BZ#1899208)

* fips mode boot is broken after adding extrng (BZ#1899584)

* pmtu of 1280 for vxlan as bridge port won''t work (BZ#1902082)

* rpc task loop with kworker spinning at 100% CPU for 10 minutes when umount an NFS 4.x share with sec=krb5 triggered by unmount of the NFS share (BZ#1907667)',
    6.7, '3.1', 'CVE', '2020-09-09T16:15:12Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/errata/RHSA-2021:0003, https://access.redhat.com/errata/RHSA-2021:0004, https://access.redhat.com/security/cve/CVE-2020-25211', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2021-47501',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2021-47501', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

i40e: Fix NULL pointer dereference in i40e_dbg_dump_desc

When trying to dump VFs VSI RX/TX descriptors
using debugfs there was a crash
due to NULL pointer dereference in i40e_dbg_dump_desc.
Added a check to i40e_dbg_dump_desc that checks if
VSI type is correct for dumping RX/TX descriptors.',
    5.5, '3.1', 'CVE', '2024-05-24T15:15:10Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/errata/RHSA-2022:1988, https://access.redhat.com/security/cve/CVE-2021-47501', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-50646',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-50646', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

scsi: hpsa: Fix possible memory leak in hpsa_init_one()

The hpda_alloc_ctlr_info() allocates h and its field reply_map. However, in
hpsa_init_one(), if alloc_percpu() failed, the hpsa_init_one() jumps to
clean1 directly, which frees h and leaks the h->reply_map.

Fix by calling hpda_free_ctlr_info() to release h->replay_map and h instead
free h directly.',
    5.5, '3.1', 'CVE', '2000-01-01T00:00:00Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/security/cve/CVE-2022-50646', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-49722',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-49722', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

ice: Fix memory corruption in VF driver

Disable VF''s RX/TX queues, when it''s disabled. VF can have queues enabled,
when it requests a reset. If PF driver assumes that VF is disabled,
while VF still has queues configured, VF may unmap DMA resources.
In such scenario device still can map packets to memory, which ends up
silently corrupting it.
Previously, VF driver could experience memory corruption, which lead to
crash:
[ 5119.170157] BUG: unable to handle kernel paging request at 00001b9780003237
[ 5119.170166] PGD 0 P4D 0
[ 5119.170173] Oops: 0002 [#1] PREEMPT_RT SMP PTI
[ 5119.170181] CPU: 30 PID: 427592 Comm: kworker/u96:2 Kdump: loaded Tainted: G        W I      --------- -  - 4.18.0-372.9.1.rt7.166.el8.x86_64 #1
[ 5119.170189] Hardware name: Dell Inc. PowerEdge R740/014X06, BIOS 2.3.10 08/15/2019
[ 5119.170193] Workqueue: iavf iavf_adminq_task [iavf]
[ 5119.170219] RIP: 0010:__page_frag_cache_drain+0x5/0x30
[ 5119.170238] Code: 0f 0f b6 77 51 85 f6 74 07 31 d2 e9 05 df ff ff e9 90 fe ff ff 48 8b 05 49 db 33 01 eb b4 0f 1f 80 00 00 00 00 0f 1f 44 00 00 <f0> 29 77 34 74 01 c3 48 8b 07 f6 c4 80 74 0f 0f b6 77 51 85 f6 74
[ 5119.170244] RSP: 0018:ffffa43b0bdcfd78 EFLAGS: 00010282
[ 5119.170250] RAX: ffffffff896b3e40 RBX: ffff8fb282524000 RCX: 0000000000000002
[ 5119.170254] RDX: 0000000049000000 RSI: 0000000000000000 RDI: 00001b9780003203
[ 5119.170259] RBP: ffff8fb248217b00 R08: 0000000000000022 R09: 0000000000000009
[ 5119.170262] R10: 2b849d6300000000 R11: 0000000000000020 R12: 0000000000000000
[ 5119.170265] R13: 0000000000001000 R14: 0000000000000009 R15: 0000000000000000
[ 5119.170269] FS:  0000000000000000(0000) GS:ffff8fb1201c0000(0000) knlGS:0000000000000000
[ 5119.170274] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5119.170279] CR2: 00001b9780003237 CR3: 00000008f3e1a003 CR4: 00000000007726e0
[ 5119.170283] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 5119.170286] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 5119.170290] PKRU: 55555554
[ 5119.170292] Call Trace:
[ 5119.170298]  iavf_clean_rx_ring+0xad/0x110 [iavf]
[ 5119.170324]  iavf_free_rx_resources+0xe/0x50 [iavf]
[ 5119.170342]  iavf_free_all_rx_resources.part.51+0x30/0x40 [iavf]
[ 5119.170358]  iavf_virtchnl_completion+0xd8a/0x15b0 [iavf]
[ 5119.170377]  ? iavf_clean_arq_element+0x210/0x280 [iavf]
[ 5119.170397]  iavf_adminq_task+0x126/0x2e0 [iavf]
[ 5119.170416]  process_one_work+0x18f/0x420
[ 5119.170429]  worker_thread+0x30/0x370
[ 5119.170437]  ? process_one_work+0x420/0x420
[ 5119.170445]  kthread+0x151/0x170
[ 5119.170452]  ? set_kthread_struct+0x40/0x40
[ 5119.170460]  ret_from_fork+0x35/0x40
[ 5119.170477] Modules linked in: iavf sctp ip6_udp_tunnel udp_tunnel mlx4_en mlx4_core nfp tls vhost_net vhost vhost_iotlb tap tun xt_CHECKSUM ipt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_ipv4 nft_compat nft_counter nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables nfnetlink bridge stp llc rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache sunrpc intel_rapl_msr iTCO_wdt iTCO_vendor_support dell_smbios wmi_bmof dell_wmi_descriptor dcdbas kvm_intel kvm irqbypass intel_rapl_common isst_if_common skx_edac irdma nfit libnvdimm x86_pkg_temp_thermal i40e intel_powerclamp coretemp crct10dif_pclmul crc32_pclmul ghash_clmulni_intel ib_uverbs rapl ipmi_ssif intel_cstate intel_uncore mei_me pcspkr acpi_ipmi ib_core mei lpc_ich i2c_i801 ipmi_si ipmi_devintf wmi ipmi_msghandler acpi_power_meter xfs libcrc32c sd_mod t10_pi sg mgag200 drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ice ahci drm libahci crc32c_intel libata tg3 megaraid_sas
[ 5119.170613]  i2c_algo_bit dm_mirror dm_region_hash dm_log dm_mod fuse [last unloaded: iavf]
[ 5119.170627] CR2: 00001b9780003237 
            The VF unmap DMA device can still map packets to memory, which ends up silently corruption leading to denial of service A:H and CI:L.',
    6.6, '3.1', 'CVE', '2025-02-26T07:01:47Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/security/cve/CVE-2022-49722', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2025-40297',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2025-40297', 'High', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

net: bridge: fix use-after-free due to MST port state bypass

syzbot reported[1] a use-after-free when deleting an expired fdb. It is
due to a race condition between learning still happening and a port being
deleted, after all its fdbs have been flushed. The port''s state has been
toggled to disabled so no learning should happen at that time, but if we
have MST enabled, it will bypass the port''s state, that together with VLAN
filtering disabled can lead to fdb learning at a time when it shouldn''t
happen while the port is being deleted. VLAN filtering must be disabled
because we flush the port VLANs when it''s being deleted which will stop
learning. This fix adds a check for the port''s vlan group which is
initialized to NULL when the port is getting deleted, that avoids the port
state bypass. When MST is enabled there would be a minimal new overhead
in the fast-path because the port''s vlan group pointer is cache-hot.

[1] https://syzkaller.appspot.com/bug?extid=dd280197f0f7ab3917be 
            Exploitation requires a bridge configuration with MST enabled and VLAN filtering disabled, combined with specific timing during port deletion. Standard bridge configurations are less likely to be affected.',
    7.0, '3.1', 'CVE', '2000-01-01T00:00:00Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/security/cve/CVE-2025-40297', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2023-53833',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2023-53833', 'High', 'Packages', '-', 'A NULL pointer dereference vulnerability was found in the Intel i915 graphics driver in the Linux kernel. The intel_atomic_get_new_crtc_state() function can return NULL if the CRTC state was not previously obtained via intel_atomic_get_crtc_state(), but the return value was not checked before use. This leads to a kernel crash when display mode changes are performed under certain conditions. 
            This is a NULL pointer dereference in the Intel i915 graphics driver that can cause a kernel crash during display configuration changes. The vulnerability requires local access and affects systems with Intel integrated graphics.
            To mitigate this issue, prevent the i915 module from being loaded. See https://access.redhat.com/solutions/41278 for instructions on how to blacklist a kernel module. Note that this will disable Intel integrated graphics.',
    7.0, '3.1', 'CVE', '2000-01-01T00:00:00Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/security/cve/CVE-2023-53833', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-48787',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-48787', 'High', 'Packages', '-', 'A use-after-free flaw was found in the Linux kernel. This issue may lead to compromised Availability.',
    7.8, '3.1', 'CVE', '2024-07-16T12:15:03Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/security/cve/CVE-2022-48787', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2021-47506',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2021-47506', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

nfsd: fix use-after-free due to delegation race

A delegation break could arrive as soon as we''ve called vfs_setlease.  A
delegation break runs a callback which immediately (in
nfsd4_cb_recall_prepare) adds the delegation to del_recall_lru.  If we
then exit nfs4_set_delegation without hashing the delegation, it will be
freed as soon as the callback is done with it, without ever being
removed from del_recall_lru.

Symptoms show up later as use-after-free or list corruption warnings,
usually in the laundromat thread.

I suspect aba2072f4523 "nfsd: grant read delegations to clients holding
writes" made this bug easier to hit, but I looked as far back as v3.0
and it looks to me it already had the same problem.  So I''m not sure
where the bug was introduced; it may have been there from the beginning.',
    5.5, '3.1', 'CVE', '2024-05-24T15:15:11Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/security/cve/CVE-2021-47506', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-2938',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-2938', 'High', 'Packages', '-', 'The kernel packages contain the Linux kernel, the core of any Linux operating system.

Security Fix(es):

* off-path attacker may inject data or terminate victim''s TCP session (CVE-2020-36516)

* race condition in VT_RESIZEX ioctl when vc_cons[i].d is already NULL leading to NULL pointer dereference (CVE-2020-36558)

* use-after-free vulnerability in function sco_sock_sendmsg() (CVE-2021-3640)

* memory leak for large arguments in video_usercopy function in drivers/media/v4l2-core/v4l2-ioctl.c (CVE-2021-30002)

* smb2_ioctl_query_info NULL Pointer Dereference (CVE-2022-0168)

* NULL pointer dereference in udf_expand_file_adinicbdue() during writeback (CVE-2022-0617)

* swiotlb information leak with DMA_FROM_DEVICE (CVE-2022-0854)

* uninitialized registers on stack in nft_do_chain can cause kernel pointer leakage to UM (CVE-2022-1016)

* race condition in snd_pcm_hw_free leading to use-after-free (CVE-2022-1048)

* use-after-free in tc_new_tfilter() in net/sched/cls_api.c (CVE-2022-1055)

* use-after-free and memory errors in ext4 when mounting and operating on a corrupted image (CVE-2022-1184)

* NULL pointer dereference in x86_emulate_insn may lead to DoS (CVE-2022-1852)

* buffer overflow in nft_set_desc_concat_parse() (CVE-2022-2078)

* nf_tables cross-table potential use-after-free may lead to local privilege escalation (CVE-2022-2586)

* openvswitch: integer underflow leads to out-of-bounds write in reserve_sfa_size() (CVE-2022-2639)

* use-after-free when psi trigger is destroyed while being polled (CVE-2022-2938)

* net/packet: slab-out-of-bounds access in packet_recvmsg() (CVE-2022-20368)

* possible to use the debugger to write zero into a location of choice (CVE-2022-21499)

* Spectre-BHB (CVE-2022-23960)

* Post-barrier Return Stack Buffer Predictions (CVE-2022-26373)

* memory leak in drivers/hid/hid-elo.c (CVE-2022-27950)

* double free in ems_usb_start_xmit in drivers/net/can/usb/ems_usb.c (CVE-2022-28390)

* use after free in SUNRPC subsystem (CVE-2022-28893)

* use-after-free due to improper update of reference count in net/sched/cls_u32.c (CVE-2022-29581)

* DoS in nfqnl_mangle in net/netfilter/nfnetlink_queue.c (CVE-2022-36946)

* nfs_atomic_open() returns uninitialized data instead of ENOTDIR (CVE-2022-24448)

For more details about the security issue(s), including the impact, a CVSS score, acknowledgments, and other related information, refer to the CVE page(s) listed in the References section.

Additional Changes:

For detailed information on changes in this release, see the Red Hat Enterprise Linux 8.7 Release Notes linked from the References section.',
    7.8, '3.1', 'CVE', '2022-08-23T20:15:08Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/errata/RHSA-2022:7444, https://access.redhat.com/errata/RHSA-2022:7683, https://access.redhat.com/security/cve/CVE-2022-2938', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2021-47507',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2021-47507', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

nfsd: Fix nsfd startup race (again)

Commit bd5ae9288d64 ("nfsd: register pernet ops last, unregister first")
has re-opened rpc_pipefs_event() race against nfsd_net_id registration
(register_pernet_subsys()) which has been fixed by commit bb7ffbf29e76
("nfsd: fix nsfd startup race triggering BUG_ON").

Restore the order of register_pernet_subsys() vs register_cld_notifier().
Add WARN_ON() to prevent a future regression.

Crash info:
Unable to handle kernel NULL pointer dereference at virtual address 0000000000000012
CPU: 8 PID: 345 Comm: mount Not tainted 5.4.144-... #1
pc : rpc_pipefs_event+0x54/0x120 [nfsd]
lr : rpc_pipefs_event+0x48/0x120 [nfsd]
Call trace:
 rpc_pipefs_event+0x54/0x120 [nfsd]
 blocking_notifier_call_chain
 rpc_fill_super
 get_tree_keyed
 rpc_fs_get_tree
 vfs_get_tree
 do_mount
 ksys_mount
 __arm64_sys_mount
 el0_svc_handler
 el0_svc 
            
            Mitigation for this issue is either not available or the currently available options do not meet the Red Hat Product Security criteria comprising ease of use and deployment, applicability to widespread installation base or stability.',
    4.4, '3.1', 'CVE', '2024-05-24T15:15:11Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/security/cve/CVE-2021-47507', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-49198',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-49198', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

mptcp: Fix crash due to tcp_tsorted_anchor was initialized before release skb

Got crash when doing pressure test of mptcp:

===========================================================================
dst_release: dst:ffffa06ce6e5c058 refcnt:-1
kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
BUG: unable to handle kernel paging request at ffffa06ce6e5c058
PGD 190a01067 P4D 190a01067 PUD 43fffb067 PMD 22e403063 PTE 8000000226e5c063
Oops: 0011 [#1] SMP PTI
CPU: 7 PID: 7823 Comm: kworker/7:0 Kdump: loaded Tainted: G            E
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.2.1 04/01/2014
Call Trace:
 ? skb_release_head_state+0x68/0x100
 ? skb_release_all+0xe/0x30
 ? kfree_skb+0x32/0xa0
 ? mptcp_sendmsg_frag+0x57e/0x750
 ? __mptcp_retrans+0x21b/0x3c0
 ? __switch_to_asm+0x35/0x70
 ? mptcp_worker+0x25e/0x320
 ? process_one_work+0x1a7/0x360
 ? worker_thread+0x30/0x390
 ? create_worker+0x1a0/0x1a0
 ? kthread+0x112/0x130
 ? kthread_flush_work_fn+0x10/0x10
 ? ret_from_fork+0x35/0x40
===========================================================================

In __mptcp_alloc_tx_skb skb was allocated and skb->tcp_tsorted_anchor will
be initialized, in under memory pressure situation sk_wmem_schedule will
return false and then kfree_skb. In this case skb->_skb_refdst is not null
because_skb_refdst and tcp_tsorted_anchor are stored in the same mem, and
kfree_skb will try to release dst and cause crash.',
    5.5, '3.1', 'CVE', '2025-02-26T07:00:56Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/security/cve/CVE-2022-49198', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2021-47517',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2021-47517', 'Medium', 'Packages', '-', 'The MITRE CVE dictionary describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

ethtool: do not perform operations on net devices being unregistered

There is a short period between a net device starts to be unregistered
and when it is actually gone. In that time frame ethtool operations
could still be performed, which might end up in unwanted or undefined
behaviours[1].

Do not allow ethtool operations after a net device starts its
unregistration. This patch targets the netlink part as the ioctl one
isn''t affected: the reference to the net device is taken and the
operation is executed within an rtnl lock section and the net device
won''t be found after unregister.

[1] For example adding Tx queues after unregister ends up in NULL
    pointer exceptions and UaFs, such as:

      BUG: KASAN: use-after-free in kobject_get+0x14/0x90
      Read of size 1 at addr ffff88801961248c by task ethtool/755

      CPU: 0 PID: 755 Comm: ethtool Not tainted 5.15.0-rc6+ #778
      Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-4.fc34 04/014
      Call Trace:
       dump_stack_lvl+0x57/0x72
       print_address_description.constprop.0+0x1f/0x140
       kasan_report.cold+0x7f/0x11b
       kobject_get+0x14/0x90
       kobject_add_internal+0x3d1/0x450
       kobject_init_and_add+0xba/0xf0
       netdev_queue_update_kobjects+0xcf/0x200
       netif_set_real_num_tx_queues+0xb4/0x310
       veth_set_channels+0x1c3/0x550
       ethnl_set_channels+0x524/0x610',
    4.4, '3.1', 'CVE', '2024-05-24T15:15:13Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/security/cve/CVE-2021-47517', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-48979',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-48979', 'Medium', 'Packages', '-', 'The MITRE CVE dictionary describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

drm/amd/display: fix array index out of bound error in DCN32 DML

[Why&How]
LinkCapacitySupport array is indexed with the number of voltage states and
not the number of max DPPs. Fix the error by changing the array
declaration to use the correct (larger) array size of total number of
voltage states.',
    4.4, '3.1', 'CVE', '2024-10-21T20:15:09Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/security/cve/CVE-2022-48979', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-3107',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-3107', 'Medium', 'Packages', '-', 'The kernel packages contain the Linux kernel, the core of any Linux operating system.

Security Fix(es):

* off-path attacker may inject data or terminate victim''s TCP session (CVE-2020-36516)

* race condition in VT_RESIZEX ioctl when vc_cons[i].d is already NULL leading to NULL pointer dereference (CVE-2020-36558)

* use-after-free vulnerability in function sco_sock_sendmsg() (CVE-2021-3640)

* memory leak for large arguments in video_usercopy function in drivers/media/v4l2-core/v4l2-ioctl.c (CVE-2021-30002)

* smb2_ioctl_query_info NULL Pointer Dereference (CVE-2022-0168)

* NULL pointer dereference in udf_expand_file_adinicbdue() during writeback (CVE-2022-0617)

* swiotlb information leak with DMA_FROM_DEVICE (CVE-2022-0854)

* uninitialized registers on stack in nft_do_chain can cause kernel pointer leakage to UM (CVE-2022-1016)

* race condition in snd_pcm_hw_free leading to use-after-free (CVE-2022-1048)

* use-after-free in tc_new_tfilter() in net/sched/cls_api.c (CVE-2022-1055)

* use-after-free and memory errors in ext4 when mounting and operating on a corrupted image (CVE-2022-1184)

* NULL pointer dereference in x86_emulate_insn may lead to DoS (CVE-2022-1852)

* buffer overflow in nft_set_desc_concat_parse() (CVE-2022-2078)

* nf_tables cross-table potential use-after-free may lead to local privilege escalation (CVE-2022-2586)

* openvswitch: integer underflow leads to out-of-bounds write in reserve_sfa_size() (CVE-2022-2639)

* use-after-free when psi trigger is destroyed while being polled (CVE-2022-2938)

* net/packet: slab-out-of-bounds access in packet_recvmsg() (CVE-2022-20368)

* possible to use the debugger to write zero into a location of choice (CVE-2022-21499)

* Spectre-BHB (CVE-2022-23960)

* Post-barrier Return Stack Buffer Predictions (CVE-2022-26373)

* memory leak in drivers/hid/hid-elo.c (CVE-2022-27950)

* double free in ems_usb_start_xmit in drivers/net/can/usb/ems_usb.c (CVE-2022-28390)

* use after free in SUNRPC subsystem (CVE-2022-28893)

* use-after-free due to improper update of reference count in net/sched/cls_u32.c (CVE-2022-29581)

* DoS in nfqnl_mangle in net/netfilter/nfnetlink_queue.c (CVE-2022-36946)

* nfs_atomic_open() returns uninitialized data instead of ENOTDIR (CVE-2022-24448)

For more details about the security issue(s), including the impact, a CVSS score, acknowledgments, and other related information, refer to the CVE page(s) listed in the References section.

Additional Changes:

For detailed information on changes in this release, see the Red Hat Enterprise Linux 8.7 Release Notes linked from the References section.',
    5.5, '3.1', 'CVE', '2022-12-14T21:15:11Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/errata/RHSA-2022:7444, https://access.redhat.com/errata/RHSA-2022:7683, https://access.redhat.com/security/cve/CVE-2022-3107', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-3239',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-3239', 'High', 'Packages', '-', 'The kernel packages contain the Linux kernel, the core of any Linux operating system.

The following packages have been upgraded to a later upstream version: kernel (4.18.0). (BZ#2122230, BZ#2122267)

Security Fix(es):

* use-after-free caused by l2cap_reassemble_sdu() in net/bluetooth/l2cap_core.c (CVE-2022-3564)

* net/ulp: use-after-free in listening ULP sockets (CVE-2023-0461)

* hw: cpu: AMD CPUs may transiently execute beyond unconditional direct branch (CVE-2021-26341)

* malicious data for FBIOPUT_VSCREENINFO ioctl may cause OOB write memory (CVE-2021-33655)

* when setting font with malicious data by ioctl PIO_FONT, kernel will write memory out of bounds (CVE-2021-33656)

* possible race condition in drivers/tty/tty_buffers.c (CVE-2022-1462)

* use-after-free in ath9k_htc_probe_device() could cause an escalation of privileges (CVE-2022-1679)

* KVM: NULL pointer dereference in kvm_mmu_invpcid_gva (CVE-2022-1789)

* KVM: nVMX: missing IBPB when exiting from nested guest can lead to Spectre v2 attacks (CVE-2022-2196)

* netfilter: nf_conntrack_irc message handling issue (CVE-2022-2663)

* race condition in xfrm_probe_algs can lead to OOB read/write (CVE-2022-3028)

* media: em28xx: initialize refcount before kref_get (CVE-2022-3239)

* race condition in hugetlb_no_page() in mm/hugetlb.c (CVE-2022-3522)

* memory leak in ipv6_renew_options() (CVE-2022-3524)

* data races around icsk->icsk_af_ops in do_ipv6_setsockopt (CVE-2022-3566)

* data races around sk->sk_prot (CVE-2022-3567)

* memory leak in l2cap_recv_acldata of the file net/bluetooth/l2cap_core.c (CVE-2022-3619)

* denial of service in follow_page_pte in mm/gup.c due to poisoned pte entry (CVE-2022-3623)

* use-after-free after failed devlink reload in devlink_param_get (CVE-2022-3625)

* USB-accessible buffer overflow in brcmfmac (CVE-2022-3628)

* Double-free in split_2MB_gtt_entry when function intel_gvt_dma_map_guest_page failed (CVE-2022-3707)

* l2tp: missing lock when clearing sk_user_data can lead to NULL pointer dereference (CVE-2022-4129)

* igmp: use-after-free in ip_check_mc_rcu when opening and closing inet sockets (CVE-2022-20141)

* Executable Space Protection Bypass (CVE-2022-25265)

* Unprivileged users may use PTRACE_SEIZE to set PTRACE_O_SUSPEND_SECCOMP option (CVE-2022-30594)

* unmap_mapping_range() race with munmap() on VM_PFNMAP mappings leads to stale TLB entry (CVE-2022-39188)

* TLB flush operations are mishandled in certain KVM_VCPU_PREEMPTED leading to guest malfunctioning (CVE-2022-39189)

* Report vmalloc UAF in dvb-core/dmxdev (CVE-2022-41218)

* u8 overflow problem in cfg80211_update_notlisted_nontrans() (CVE-2022-41674)

* use-after-free related to leaf anon_vma double reuse (CVE-2022-42703)

* use-after-free in bss_ref_get in net/wireless/scan.c (CVE-2022-42720)

* BSS list corruption in cfg80211_add_nontrans_list in net/wireless/scan.c (CVE-2022-42721)

* Denial of service in beacon protection for P2P-device (CVE-2022-42722)

* memory corruption in usbmon driver (CVE-2022-43750)

* NULL pointer dereference in traffic control subsystem (CVE-2022-47929)

* NULL pointer dereference in rawv6_push_pending_frames (CVE-2023-0394)

* use-after-free caused by invalid pointer hostname in fs/cifs/connect.c (CVE-2023-1195)

* Soft lockup occurred during __page_mapcount (CVE-2023-1582)

* slab-out-of-bounds read vulnerabilities in cbq_classify (CVE-2023-23454)

For more details about the security issue(s), including the impact, a CVSS score, acknowledgments, and other related information, refer to the CVE page(s) listed in the References section.

Additional Changes:

For detailed information on changes in this release, see the Red Hat Enterprise Linux 8.8 Release Notes linked from the References section.',
    7.0, '3.1', 'CVE', '2022-09-19T20:15:12Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/errata/RHSA-2023:2736, https://access.redhat.com/errata/RHSA-2023:2951, https://access.redhat.com/security/cve/CVE-2022-3239', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2021-47527',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2021-47527', 'Medium', 'Packages', '-', 'The kernel packages contain the Linux kernel, the core of any Linux operating system.  
Security Fix(es):

 CVE-2023-6040  CVE-2024-26595  CVE-2024-26600  CVE-2021-46984  CVE-2023-52478  CVE-2023-52476  CVE-2023-52522  CVE-2021-47101  CVE-2021-47097  CVE-2023-52605  CVE-2024-26638  CVE-2024-26645  CVE-2024-26665  CVE-2024-26720  CVE-2024-26717  CVE-2024-26769  CVE-2024-26846  CVE-2024-26894  CVE-2024-26880  CVE-2024-26855  CVE-2024-26923  CVE-2024-26939  CVE-2024-27013  CVE-2024-27042  CVE-2024-35809  CVE-2023-52683  CVE-2024-35884  CVE-2024-35877  CVE-2024-35944  CVE-2024-35989  CVE-2021-47412  CVE-2021-47393  CVE-2021-47386  CVE-2021-47385  CVE-2021-47384  CVE-2021-47383  CVE-2021-47432  CVE-2021-47352  CVE-2021-47338  CVE-2021-47321  CVE-2021-47289  CVE-2021-47287  CVE-2023-52798  CVE-2023-52809  CVE-2023-52817  CVE-2023-52840  CVE-2023-52800  CVE-2021-47441  CVE-2021-47466  CVE-2021-47455  CVE-2021-47497  CVE-2021-47560  CVE-2021-47527  CVE-2024-36883  CVE-2024-36922  CVE-2024-36920  CVE-2024-36902  CVE-2024-36953  CVE-2024-36939  CVE-2024-36919  CVE-2024-36901  CVE-2021-47582  CVE-2021-47609  CVE-2024-38619  CVE-2022-48754  CVE-2022-48760  CVE-2024-38581  CVE-2024-38579  CVE-2024-38570  CVE-2024-38559  CVE-2024-38558  CVE-2024-37356  CVE-2024-39471  CVE-2024-39499  CVE-2024-39501  CVE-2024-39506  CVE-2024-40904  CVE-2024-40911  CVE-2024-40912  CVE-2024-40929  CVE-2024-40931  CVE-2024-40941  CVE-2024-40954  CVE-2024-40958  CVE-2024-40959  CVE-2024-40960  CVE-2024-40972  CVE-2024-40977  CVE-2024-40978  CVE-2024-40988  CVE-2024-40989  CVE-2024-40995  CVE-2024-40997  CVE-2024-40998  CVE-2024-41005  CVE-2024-40901  CVE-2024-41007  CVE-2024-41008  CVE-2022-48804  CVE-2022-48836  CVE-2022-48866  CVE-2024-41090  CVE-2024-41091  CVE-2024-41012  CVE-2024-41013  CVE-2024-41014  CVE-2024-41023  CVE-2024-41035  CVE-2024-41038  CVE-2024-41039  CVE-2024-41040  CVE-2024-41041  CVE-2024-41044  CVE-2024-41055  CVE-2024-41056  CVE-2024-41060  CVE-2024-41064  CVE-2024-41065  CVE-2024-41071  CVE-2024-41076  CVE-2024-41097  CVE-2024-42084  CVE-2024-42090  CVE-2024-42094  CVE-2024-42096  CVE-2024-42114  CVE-2024-42124  CVE-2024-42131  CVE-2024-42152  CVE-2024-42154  CVE-2024-42225  CVE-2024-42226  CVE-2024-42228  CVE-2024-42237  CVE-2024-42238  CVE-2024-42240  CVE-2024-42246  CVE-2024-42322  CVE-2024-43830  CVE-2024-43871  For more details about the security issue(s), including the impact, a CVSS score, acknowledgments, and other related information, refer to the CVE page(s) listed in the References section.',
    5.5, '3.1', 'CVE', '2024-05-24T15:15:15Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/errata/RHSA-2024:7000, https://access.redhat.com/errata/RHSA-2024:7001, https://access.redhat.com/security/cve/CVE-2021-47527', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-49888',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-49888', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

arm64: entry: avoid kprobe recursion

The cortex_a76_erratum_1463225_debug_handler() function is called when
handling debug exceptions (and synchronous exceptions from BRK
instructions), and so is called when a probed function executes. If the
compiler does not inline cortex_a76_erratum_1463225_debug_handler(), it
can be probed.

If cortex_a76_erratum_1463225_debug_handler() is probed, any debug
exception or software breakpoint exception will result in recursive
exceptions leading to a stack overflow. This can be triggered with the
ftrace multiple_probes selftest, and as per the example splat below.

This is a regression caused by commit:

  6459b8469753e9fe ("arm64: entry: consolidate Cortex-A76 erratum 1463225 workaround")

... which removed the NOKPROBE_SYMBOL() annotation associated with the
function.

My intent was that cortex_a76_erratum_1463225_debug_handler() would be
inlined into its caller, el1_dbg(), which is marked noinstr and cannot
be probed. Mark cortex_a76_erratum_1463225_debug_handler() as
__always_inline to ensure this.

Example splat prior to this patch (with recursive entries elided):

| # echo p cortex_a76_erratum_1463225_debug_handler > /sys/kernel/debug/tracing/kprobe_events
| # echo p do_el0_svc >> /sys/kernel/debug/tracing/kprobe_events
| # echo 1 > /sys/kernel/debug/tracing/events/kprobes/enable
| Insufficient stack space to handle exception!
| ESR: 0x0000000096000047 -- DABT (current EL)
| FAR: 0xffff800009cefff0
| Task stack:     [0xffff800009cf0000..0xffff800009cf4000]
| IRQ stack:      [0xffff800008000000..0xffff800008004000]
| Overflow stack: [0xffff00007fbc00f0..0xffff00007fbc10f0]
| CPU: 0 PID: 145 Comm: sh Not tainted 6.0.0 #2
| Hardware name: linux,dummy-virt (DT)
| pstate: 604003c5 (nZCv DAIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
| pc : arm64_enter_el1_dbg+0x4/0x20
| lr : el1_dbg+0x24/0x5c
| sp : ffff800009cf0000
| x29: ffff800009cf0000 x28: ffff000002c74740 x27: 0000000000000000
| x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
| x23: 00000000604003c5 x22: ffff80000801745c x21: 0000aaaac95ac068
| x20: 00000000f2000004 x19: ffff800009cf0040 x18: 0000000000000000
| x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
| x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
| x11: 0000000000000010 x10: ffff800008c87190 x9 : ffff800008ca00d0
| x8 : 000000000000003c x7 : 0000000000000000 x6 : 0000000000000000
| x5 : 0000000000000000 x4 : 0000000000000000 x3 : 00000000000043a4
| x2 : 00000000f2000004 x1 : 00000000f2000004 x0 : ffff800009cf0040
| Kernel panic - not syncing: kernel stack overflow
| CPU: 0 PID: 145 Comm: sh Not tainted 6.0.0 #2
| Hardware name: linux,dummy-virt (DT)
| Call trace:
|  dump_backtrace+0xe4/0x104
|  show_stack+0x18/0x4c
|  dump_stack_lvl+0x64/0x7c
|  dump_stack+0x18/0x38
|  panic+0x14c/0x338
|  test_taint+0x0/0x2c
|  panic_bad_stack+0x104/0x118
|  handle_bad_stack+0x34/0x48
|  __bad_stack+0x78/0x7c
|  arm64_enter_el1_dbg+0x4/0x20
|  el1h_64_sync_handler+0x40/0x98
|  el1h_64_sync+0x64/0x68
|  cortex_a76_erratum_1463225_debug_handler+0x0/0x34
...
|  el1h_64_sync_handler+0x40/0x98
|  el1h_64_sync+0x64/0x68
|  cortex_a76_erratum_1463225_debug_handler+0x0/0x34
...
|  el1h_64_sync_handler+0x40/0x98
|  el1h_64_sync+0x64/0x68
|  cortex_a76_erratum_1463225_debug_handler+0x0/0x34
|  el1h_64_sync_handler+0x40/0x98
|  el1h_64_sync+0x64/0x68
|  do_el0_svc+0x0/0x28
|  el0t_64_sync_handler+0x84/0xf0
|  el0t_64_sync+0x18c/0x190
| Kernel Offset: disabled
| CPU features: 0x0080,00005021,19001080
| Memory Limit: none
| ---[ end Kernel panic - not syncing: kernel stack overflow ]---

With this patch, cortex_a76_erratum_1463225_debug_handler() is inlined
into el1_dbg(), and el1_dbg() cannot be probed:

| # echo p cortex_a76_erratum_1463225_debug_handler > /sys/kernel/debug/tracing/kprobe_events
| sh: write error: No such file or directory
| # grep -w cortex_a76_errat
---truncated--- 
            The patch prevents a kprobe-induced recu...',
    4.4, '3.1', 'CVE', '2025-05-01T15:16:13Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/security/cve/CVE-2022-49888', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-48913',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-48913', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

blktrace: fix use after free for struct blk_trace

When tracing the whole disk, ''dropped'' and ''msg'' will be created
under ''q->debugfs_dir'' and ''bt->dir'' is NULL, thus blk_trace_free()
won''t remove those files. What''s worse, the following UAF can be
triggered because of accessing stale ''dropped'' and ''msg'':

==================================================================
BUG: KASAN: use-after-free in blk_dropped_read+0x89/0x100
Read of size 4 at addr ffff88816912f3d8 by task blktrace/1188

CPU: 27 PID: 1188 Comm: blktrace Not tainted 5.17.0-rc4-next-20220217+ #469
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-4
Call Trace:
 <TASK>
 dump_stack_lvl+0x34/0x44
 print_address_description.constprop.0.cold+0xab/0x381
 ? blk_dropped_read+0x89/0x100
 ? blk_dropped_read+0x89/0x100
 kasan_report.cold+0x83/0xdf
 ? blk_dropped_read+0x89/0x100
 kasan_check_range+0x140/0x1b0
 blk_dropped_read+0x89/0x100
 ? blk_create_buf_file_callback+0x20/0x20
 ? kmem_cache_free+0xa1/0x500
 ? do_sys_openat2+0x258/0x460
 full_proxy_read+0x8f/0xc0
 vfs_read+0xc6/0x260
 ksys_read+0xb9/0x150
 ? vfs_write+0x3d0/0x3d0
 ? fpregs_assert_state_consistent+0x55/0x60
 ? exit_to_user_mode_prepare+0x39/0x1e0
 do_syscall_64+0x35/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fbc080d92fd
Code: ce 20 00 00 75 10 b8 00 00 00 00 0f 05 48 3d 01 f0 ff ff 73 31 c3 48 83 1
RSP: 002b:00007fbb95ff9cb0 EFLAGS: 00000293 ORIG_RAX: 0000000000000000
RAX: ffffffffffffffda RBX: 00007fbb95ff9dc0 RCX: 00007fbc080d92fd
RDX: 0000000000000100 RSI: 00007fbb95ff9cc0 RDI: 0000000000000045
RBP: 0000000000000045 R08: 0000000000406299 R09: 00000000fffffffd
R10: 000000000153afa0 R11: 0000000000000293 R12: 00007fbb780008c0
R13: 00007fbb78000938 R14: 0000000000608b30 R15: 00007fbb780029c8
 </TASK>

Allocated by task 1050:
 kasan_save_stack+0x1e/0x40
 __kasan_kmalloc+0x81/0xa0
 do_blk_trace_setup+0xcb/0x410
 __blk_trace_setup+0xac/0x130
 blk_trace_ioctl+0xe9/0x1c0
 blkdev_ioctl+0xf1/0x390
 __x64_sys_ioctl+0xa5/0xe0
 do_syscall_64+0x35/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 1050:
 kasan_save_stack+0x1e/0x40
 kasan_set_track+0x21/0x30
 kasan_set_free_info+0x20/0x30
 __kasan_slab_free+0x103/0x180
 kfree+0x9a/0x4c0
 __blk_trace_remove+0x53/0x70
 blk_trace_ioctl+0x199/0x1c0
 blkdev_common_ioctl+0x5e9/0xb30
 blkdev_ioctl+0x1a5/0x390
 __x64_sys_ioctl+0xa5/0xe0
 do_syscall_64+0x35/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff88816912f380
 which belongs to the cache kmalloc-96 of size 96
The buggy address is located 88 bytes inside of
 96-byte region [ffff88816912f380, ffff88816912f3e0)
The buggy address belongs to the page:
page:000000009a1b4e7c refcount:1 mapcount:0 mapping:0000000000000000 index:0x0f
flags: 0x17ffffc0000200(slab|node=0|zone=2|lastcpupid=0x1fffff)
raw: 0017ffffc0000200 ffffea00044f1100 dead000000000002 ffff88810004c780
raw: 0000000000000000 0000000000200020 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88816912f280: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
 ffff88816912f300: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
>ffff88816912f380: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
                                                    ^
 ffff88816912f400: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
 ffff88816912f480: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
==================================================================',
    6.7, '3.1', 'CVE', '2024-08-22T02:15:05Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/security/cve/CVE-2022-48913', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2021-47529',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2021-47529', 'Medium', 'Packages', '-', 'The MITRE CVE dictionary describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

iwlwifi: Fix memory leaks in error handling path

Should an error occur (invalid TLV len or memory allocation failure), the
memory already allocated in ''reduce_power_data'' should be freed before
returning, otherwise it is leaking.',
    4.4, '3.1', 'CVE', '2024-05-24T15:15:15Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/security/cve/CVE-2021-47529', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-48744',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-48744', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

net/mlx5e: Avoid field-overflowing memcpy()

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally writing across neighboring fields.

Use flexible arrays instead of zero-element arrays (which look like they
are always overflowing) and split the cross-field memcpy() into two halves
that can be appropriately bounds-checked by the compiler.

We were doing:

	#define ETH_HLEN  14
	#define VLAN_HLEN  4
	...
	#define MLX5E_XDP_MIN_INLINE (ETH_HLEN + VLAN_HLEN)
	...
        struct mlx5e_tx_wqe      *wqe  = mlx5_wq_cyc_get_wqe(wq, pi);
	...
        struct mlx5_wqe_eth_seg  *eseg = &wqe->eth;
        struct mlx5_wqe_data_seg *dseg = wqe->data;
	...
	memcpy(eseg->inline_hdr.start, xdptxd->data, MLX5E_XDP_MIN_INLINE);

target is wqe->eth.inline_hdr.start (which the compiler sees as being
2 bytes in size), but copying 18, intending to write across start
(really vlan_tci, 2 bytes). The remaining 16 bytes get written into
wqe->data[0], covering byte_count (4 bytes), lkey (4 bytes), and addr
(8 bytes).

struct mlx5e_tx_wqe {
        struct mlx5_wqe_ctrl_seg   ctrl;                 /*     0    16 */
        struct mlx5_wqe_eth_seg    eth;                  /*    16    16 */
        struct mlx5_wqe_data_seg   data[];               /*    32     0 */

        /* size: 32, cachelines: 1, members: 3 */
        /* last cacheline: 32 bytes */
};

struct mlx5_wqe_eth_seg {
        u8                         swp_outer_l4_offset;  /*     0     1 */
        u8                         swp_outer_l3_offset;  /*     1     1 */
        u8                         swp_inner_l4_offset;  /*     2     1 */
        u8                         swp_inner_l3_offset;  /*     3     1 */
        u8                         cs_flags;             /*     4     1 */
        u8                         swp_flags;            /*     5     1 */
        __be16                     mss;                  /*     6     2 */
        __be32                     flow_table_metadata;  /*     8     4 */
        union {
                struct {
                        __be16     sz;                   /*    12     2 */
                        u8         start[2];             /*    14     2 */
                } inline_hdr;                            /*    12     4 */
                struct {
                        __be16     type;                 /*    12     2 */
                        __be16     vlan_tci;             /*    14     2 */
                } insert;                                /*    12     4 */
                __be32             trailer;              /*    12     4 */
        };                                               /*    12     4 */

        /* size: 16, cachelines: 1, members: 9 */
        /* last cacheline: 16 bytes */
};

struct mlx5_wqe_data_seg {
        __be32                     byte_count;           /*     0     4 */
        __be32                     lkey;                 /*     4     4 */
        __be64                     addr;                 /*     8     8 */

        /* size: 16, cachelines: 1, members: 3 */
        /* last cacheline: 16 bytes */
};

So, split the memcpy() so the compiler can reason about the buffer
sizes.

"pahole" shows no size nor member offset changes to struct mlx5e_tx_wqe
nor struct mlx5e_umr_wqe. "objdump -d" shows no meaningful object
code changes (i.e. only source line number induced differences and
optimizations). 
            
            Mitigation for this issue is either not available or the currently available options do not meet the Red Hat Product Security criteria comprising ease of use and deployment, applicability to widespread installation base or stability.',
    6.7, '3.1', 'CVE', '2024-06-20T12:15:12Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/security/cve/CVE-2022-48744', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2021-47552',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2021-47552', 'Medium', 'Packages', '-', 'A vulnerability was found in the Linux kernel''s block blk-mq when dispatch work was handled during queue cleanup. This issue occurs when dispatch work is not properly canceled in both the blk_cleanup_queue() and disk_release() functions, which can lead to a NULL pointer dereference if the associated SCSI device is freed before dispatch work is completed, resulting in kernel crashes and disruption in block device operations. 
            
            Mitigation for this issue is either not available or the currently available options do not meet the Red Hat Product Security criteria comprising ease of use and deployment, applicability to widespread installation base or stability.',
    4.4, '3.1', 'CVE', '2024-05-24T15:15:20Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/security/cve/CVE-2021-47552', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2022-48800',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2022-48800', 'Medium', 'Packages', '-', 'The MITRE CVE dictionary describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

mm: vmscan: remove deadlock due to throttling failing to make progress

A soft lockup bug in kcompactd was reported in a private bugzilla with
the following visible in dmesg;

  watchdog: BUG: soft lockup - CPU#33 stuck for 26s! [kcompactd0:479]
  watchdog: BUG: soft lockup - CPU#33 stuck for 52s! [kcompactd0:479]
  watchdog: BUG: soft lockup - CPU#33 stuck for 78s! [kcompactd0:479]
  watchdog: BUG: soft lockup - CPU#33 stuck for 104s! [kcompactd0:479]

The machine had 256G of RAM with no swap and an earlier failed
allocation indicated that node 0 where kcompactd was run was potentially
unreclaimable;

  Node 0 active_anon:29355112kB inactive_anon:2913528kB active_file:0kB
    inactive_file:0kB unevictable:64kB isolated(anon):0kB isolated(file):0kB
    mapped:8kB dirty:0kB writeback:0kB shmem:26780kB shmem_thp:
    0kB shmem_pmdmapped: 0kB anon_thp: 23480320kB writeback_tmp:0kB
    kernel_stack:2272kB pagetables:24500kB all_unreclaimable? yes

Vlastimil Babka investigated a crash dump and found that a task
migrating pages was trying to drain PCP lists;

  PID: 52922  TASK: ffff969f820e5000  CPU: 19  COMMAND: "kworker/u128:3"
  Call Trace:
     __schedule
     schedule
     schedule_timeout
     wait_for_completion
     __flush_work
     __drain_all_pages
     __alloc_pages_slowpath.constprop.114
     __alloc_pages
     alloc_migration_target
     migrate_pages
     migrate_to_node
     do_migrate_pages
     cpuset_migrate_mm_workfn
     process_one_work
     worker_thread
     kthread
     ret_from_fork

This failure is specific to CONFIG_PREEMPT=n builds.  The root of the
problem is that kcompact0 is not rescheduling on a CPU while a task that
has isolated a large number of the pages from the LRU is waiting on
kcompact0 to reschedule so the pages can be released.  While
shrink_inactive_list() only loops once around too_many_isolated, reclaim
can continue without rescheduling if sc->skipped_deactivate == 1 which
could happen if there was no file LRU and the inactive anon list was not
low.',
    5.5, '3.1', 'CVE', '2024-07-16T12:15:04Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/security/cve/CVE-2022-48800', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
),
(
    '010_ebf08fc2097c27476cabf33027f02261906886ad_CVE-2021-47554',
    '010', 'Wazuh_Loa', 'Wazuh', 'v4.7.0',
    'CentOS Stream 8', '4.18.0-448.el8.x86_64', 'CentOS Stream', 'centos', '8',
    'kernel', '4.18.0-193.19.1.el8_2', 'x86_64', 'rpm', NULL, '2020-10-23T00:17:13.000Z',
    'CVE-2021-47554', 'Medium', 'Packages', '-', 'The CVE program describes this issue as: In the Linux kernel, the following vulnerability has been resolved:

vdpa_sim: avoid putting an uninitialized iova_domain

The system will crash if we put an uninitialized iova_domain, this
could happen when an error occurs before initializing the iova_domain
in vdpasim_create().

BUG: kernel NULL pointer dereference, address: 0000000000000000
...
RIP: 0010:__cpuhp_state_remove_instance+0x96/0x1c0
...
Call Trace:
 <TASK>
 put_iova_domain+0x29/0x220
 vdpasim_free+0xd1/0x120 [vdpa_sim]
 vdpa_release_dev+0x21/0x40 [vdpa]
 device_release+0x33/0x90
 kobject_release+0x63/0x160
 vdpasim_create+0x127/0x2a0 [vdpa_sim]
 vdpasim_net_dev_add+0x7d/0xfe [vdpa_sim_net]
 vdpa_nl_cmd_dev_add_set_doit+0xe1/0x1a0 [vdpa]
 genl_family_rcv_msg_doit+0x112/0x140
 genl_rcv_msg+0xdf/0x1d0
 ...

So we must make sure the iova_domain is already initialized before
put it.

In addition, we may get the following warning in this case:
WARNING: ... drivers/iommu/iova.c:344 iova_cache_put+0x58/0x70

So we must make sure the iova_cache_put() is invoked only if the
iova_cache_get() is already invoked. Let''s fix it together.',
    4.4, '3.1', 'CVE', '2024-05-24T15:15:20Z', '2026-01-05T16:09:36.536Z',
    'https://access.redhat.com/security/cve/CVE-2021-47554', 'Wazuh', 'Red Hat CVE Database', FALSE,
    'eduardosilva-Standard-PC-i440FX-PIIX-1996', '1.0.0'
);

-- 100 registros insertados correctamente.