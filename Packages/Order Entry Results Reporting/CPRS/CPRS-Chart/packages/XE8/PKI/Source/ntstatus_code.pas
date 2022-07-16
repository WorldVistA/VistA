unit ntstatus_code;

interface

{
  Values are 32 bit and are laid out as follows. The following diagram is independent of endianness); that is, the diagram is shown in host byte order and merely shows the layout of the numbering space.

  Any protocol that uses NTSTATUS values on the wire is responsible for stating the order that the bytes are placed on the wire.

  _________________________________________________________________
  | | | | | | | | | | |1| | | | | | | | | |2| | | | | | | | | |3| |
  |0|1|2|3|4|5|6|7|8|9|0|1|2|3|4|5|6|7|8|9|0|1|2|3|4|5|6|7|8|9|0|1|
  -----------------------------------------------------------------
  |Sev|C|N| Facility              | Code                          |
  -----------------------------------------------------------------

  Sev ( 2 bits) : Severity
  $0 = Success
  $1 = Informational
  $2 = Warning
  $3 = Error

  C (1 bit) : Customer
  This specifies if the value is customer- or Microsoft-defined.  This bit is set
  for customer-defined values and clear for Microsoft-defined values.

  N (1 bit) : Reserved
  MUST be set to 0 so that it is possible to map an NTSTATUS value to an equivalent
  HRESULT value, as specified in section 2.1, by setting this bit.

  Facility : (12 bits)
  A value that, together with the C bit, indicates the numbering space to use for
  the Code field.

  Code : (2 bytes)
  The remainder of the error code. Vendors SHOULD reuse the values in the following
  table with their indicated meaning or define their own values with the C bit set.
  Choosing any other value with the C bit clear runs the risk of a collision in the
  future.
}

const
  STATUS_SUCCESS = HRESULT($00000000); // The operation completed successfully.
  STATUS_WAIT_0  = HRESULT($00000000);
  // The caller specified WaitAny for WaitType and one of the dispatcher objects in the Object array has been set to the signaled state.
  STATUS_WAIT_1 = HRESULT($00000001);
  // The caller specified WaitAny for WaitType and one of the dispatcher objects in the Object array has been set to the signaled state.
  STATUS_WAIT_2 = HRESULT($00000002);
  // The caller specified WaitAny for WaitType and one of the dispatcher objects in the Object array has been set to the signaled state.
  STATUS_WAIT_3 = HRESULT($00000003);
  // The caller specified WaitAny for WaitType and one of the dispatcher objects in the Object array has been set to the signaled state.
  STATUS_WAIT_63 = HRESULT($0000003F);
  // The caller specified WaitAny for WaitType and one of the dispatcher objects in the Object array has been set to the signaled state.
  STATUS_ABANDONED = HRESULT($00000080);
  // The caller attempted to wait for a mutex that has been abandoned.
  STATUS_ABANDONED_WAIT_0 = HRESULT($00000080);
  // The caller attempted to wait for a mutex that has been abandoned.
  STATUS_ABANDONED_WAIT_63 = HRESULT($000000BF);
  // The caller attempted to wait for a mutex that has been abandoned.
  STATUS_USER_APC = HRESULT($000000C0);
  // A user-mode APC was delivered before the given Interval expired.
  STATUS_ALERTED = HRESULT($00000101);
  // The delay completed because the thread was alerted.
  STATUS_TIMEOUT = HRESULT($00000102); // The given Timeout interval expired.
  STATUS_PENDING = HRESULT($00000103);
  // The operation that was requested is pending completion.
  STATUS_REPARSE = HRESULT($00000104);
  // A reparse should be performed by the Object Manager because the name of the file resulted in a symbolic link.
  STATUS_MORE_ENTRIES = HRESULT($00000105);
  // Returned by enumeration APIs to indicate more information is available to successive calls.
  STATUS_NOT_ALL_ASSIGNED = HRESULT($00000106);
  // Indicates not all privileges or groups that are referenced are assigned to the caller. This allows, for example, all privileges to be disabled without having to know exactly which privileges are assigned.
  STATUS_SOME_NOT_MAPPED = HRESULT($00000107);
  // Some of the information to be translated has not been translated.
  STATUS_OPLOCK_BREAK_IN_PROGRESS = HRESULT($00000108);
  // An open/create operation completed while an opportunistic lock (oplock) break is underway.
  STATUS_VOLUME_MOUNTED = HRESULT($00000109);
  // A new volume has been mounted by a file system.
  STATUS_RXACT_COMMITTED = HRESULT($0000010A);
  // This success level status indicates that the transaction state already exists for the registry subtree but that a transaction commit was previously aborted. The commit has now been completed.
  STATUS_NOTIFY_CLEANUP = HRESULT($0000010B);
  // Indicates that a notify change request has been completed due to closing the handle that made the notify change request.
  STATUS_NOTIFY_ENUM_DIR = HRESULT($0000010C);
  // Indicates that a notify change request is being completed and that the information is not being returned in the caller's buffer. The caller now needs to enumerate the files to find the changes.
  STATUS_NO_QUOTAS_FOR_ACCOUNT = HRESULT($0000010D);
  // {No Quotas} No system quota limits are specifically set for this account.
  STATUS_PRIMARY_TRANSPORT_CONNECT_FAILED = HRESULT($0000010E);
  // {Connect Failure on Primary Transport} An attempt was made to connect to the remote server %hs on the primary transport, but the connection failed. The computer WAS able to connect on a secondary transport.
  STATUS_PAGE_FAULT_TRANSITION = HRESULT($00000110);
  // The page fault was a transition fault.
  STATUS_PAGE_FAULT_DEMAND_ZERO = HRESULT($00000111);
  // The page fault was a demand zero fault.
  STATUS_PAGE_FAULT_COPY_ON_WRITE = HRESULT($00000112);
  // The page fault was a demand zero fault.
  STATUS_PAGE_FAULT_GUARD_PAGE = HRESULT($00000113);
  // The page fault was a demand zero fault.
  STATUS_PAGE_FAULT_PAGING_FILE = HRESULT($00000114);
  // The page fault was satisfied by reading from a secondary storage device.
  STATUS_CACHE_PAGE_LOCKED = HRESULT($00000115);
  // The cached page was locked during operation.
  STATUS_CRASH_DUMP = HRESULT($00000116); // The crash dump exists in a paging file.
  STATUS_BUFFER_ALL_ZEROS = HRESULT($00000117);
  // The specified buffer contains all zeros.
  STATUS_REPARSE_OBJECT = HRESULT($00000118);
  // A reparse should be performed by the Object Manager because the name of the file resulted in a symbolic link.
  STATUS_RESOURCE_REQUIREMENTS_CHANGED = HRESULT($00000119);
  // The device has succeeded a query-stop and its resource requirements have changed.
  STATUS_TRANSLATION_COMPLETE = HRESULT($00000120);
  // The translator has translated these resources into the global space and no additional translations should be performed.
  STATUS_DS_MEMBERSHIP_EVALUATED_LOCALLY = HRESULT($00000121);
  // The directory service evaluated group memberships locally, because it was unable to contact a global catalog server.
  STATUS_NOTHING_TO_TERMINATE = HRESULT($00000122);
  // A process being terminated has no threads to terminate.
  STATUS_PROCESS_NOT_IN_JOB = HRESULT($00000123);
  // The specified process is not part of a job.
  STATUS_PROCESS_IN_JOB = HRESULT($00000124); // The specified process is part of a job.
  STATUS_VOLSNAP_HIBERNATE_READY = HRESULT($00000125);
  // {Volume Shadow Copy Service} The system is now ready for hibernation.
  STATUS_FSFILTER_OP_COMPLETED_SUCCESSFULLY = HRESULT($00000126);
  // A file system or file system filter driver has successfully completed an FsFilter operation.
  STATUS_INTERRUPT_VECTOR_ALREADY_CONNECTED = HRESULT($00000127);
  // The specified interrupt vector was already connected.
  STATUS_INTERRUPT_STILL_CONNECTED = HRESULT($00000128);
  // The specified interrupt vector is still connected.
  STATUS_PROCESS_CLONED = HRESULT($00000129); // The current process is a cloned process.
  STATUS_FILE_LOCKED_WITH_ONLY_READERS = HRESULT($0000012A);
  // The file was locked and all users of the file can only read.
  STATUS_FILE_LOCKED_WITH_WRITERS = HRESULT($0000012B);
  // The file was locked and at least one user of the file can write.
  STATUS_RESOURCEMANAGER_READ_ONLY = HRESULT($00000202);
  // The specified ResourceManager made no changes or updates to the resource under this transaction.
  STATUS_WAIT_FOR_OPLOCK = HRESULT($00000367);
  // An operation is blocked and waiting for an oplock.
  DBG_EXCEPTION_HANDLED  = HRESULT($00010001); // Debugger handled the exception.
  DBG_CONTINUE           = HRESULT($00010002); // The debugger continued.
  STATUS_FLT_IO_COMPLETE = HRESULT($001C0001); // The IO was completed by a filter.
  STATUS_FILE_NOT_AVAILABLE = HRESULT($C0000467); // The file is temporarily unavailable.
  STATUS_SHARE_UNAVAILABLE = HRESULT($C0000480); // The share is temporarily unavailable.
  STATUS_CALLBACK_RETURNED_THREAD_AFFINITY = HRESULT($C0000721);
  // A threadpool worker thread entered a callback at thread affinity %p and exited at affinity %p.  This is unexpected, indicating that the callback missed restoring the priority.
  STATUS_OBJECT_NAME_EXISTS = HRESULT($40000000);
  // {Object Exists} An attempt was made to create an object but the object name already exists.
  STATUS_THREAD_WAS_SUSPENDED = HRESULT($40000001);
  // {Thread Suspended} A thread termination occurred while the thread was suspended. The thread resumed, and termination proceeded.
  STATUS_WORKING_SET_LIMIT_RANGE = HRESULT($40000002);
  // {Working Set Range Error} An attempt was made to set the working set minimum or maximum to values that are outside the allowable range.
  STATUS_IMAGE_NOT_AT_BASE = HRESULT($40000003);
  // {Image Relocated} An image file could not be mapped at the address that is specified in the image file. Local fixes must be performed on this image.
  STATUS_RXACT_STATE_CREATED = HRESULT($40000004);
  // This informational level status indicates that a specified registry subtree transaction state did not yet exist and had to be created.
  STATUS_SEGMENT_NOTIFICATION = HRESULT($40000005);
  // {Segment Load} A virtual DOS machine (VDM) is loading, unloading, or moving an MS-DOS or Win16 program segment image. An exception is raised so that a debugger can load, unload, or track symbols and breakpoints within these 16-bit segments.
  STATUS_LOCAL_USER_SESSION_KEY = HRESULT($40000006);
  // {Local Session Key} A user session key was requested for a local remote procedure call (RPC) connection. The session key that is returned is a constant value and not unique to this connection.
  STATUS_BAD_CURRENT_DIRECTORY = HRESULT($40000007);
  // {Invalid Current Directory} The process cannot switch to the startup current directory %hs. Select OK to set the current directory to %hs, or select CANCEL to exit.
  STATUS_SERIAL_MORE_WRITES = HRESULT($40000008);
  // {Serial IOCTL Complete} A serial I/O operation was completed by another write to a serial port. (The IOCTL_SERIAL_XOFF_COUNTER reached zero.)
  STATUS_REGISTRY_RECOVERED = HRESULT($40000009);
  // {Registry Recovery} One of the files that contains the system registry data had to be recovered by using a log or alternate copy. The recovery was successful.
  STATUS_FT_READ_RECOVERY_FROM_BACKUP = HRESULT($4000000A);
  // {Redundant Read} To satisfy a read request, the Windows NT operating system fault-tolerant file system successfully read the requested data from a redundant copy. This was done because the file system encountered a failure on a member of the fault-tolerant volume but was unable to reassign the failing area of the device.
  STATUS_FT_WRITE_RECOVERY = HRESULT($4000000B);
  // {Redundant Write} To satisfy a write request, the Windows NT fault-tolerant file system successfully wrote a redundant copy of the information. This was done because the file system encountered a failure on a member of the fault-tolerant volume but was unable to reassign the failing area of the device.
  STATUS_SERIAL_COUNTER_TIMEOUT = HRESULT($4000000C);
  // {Serial IOCTL Timeout} A serial I/O operation completed because the time-out period expired. (The IOCTL_SERIAL_XOFF_COUNTER had not reached zero.)
  STATUS_NULL_LM_PASSWORD = HRESULT($4000000D);
  // {Password Too Complex} The Windows password is too complex to be converted to a LAN Manager password. The LAN Manager password that returned is a NULL string.
  STATUS_IMAGE_MACHINE_TYPE_MISMATCH = HRESULT($4000000E);
  // {Machine Type Mismatch} The image file %hs is valid but is for a machine type other than the current machine. Select OK to continue, or CANCEL to fail the DLL load.
  STATUS_RECEIVE_PARTIAL = HRESULT($4000000F);
  // {Partial Data Received} The network transport returned partial data to its client. The remaining data will be sent later.
  STATUS_RECEIVE_EXPEDITED = HRESULT($40000010);
  // {Expedited Data Received} The network transport returned data to its client that was marked as expedited by the remote system.
  STATUS_RECEIVE_PARTIAL_EXPEDITED = HRESULT($40000011);
  // {Partial Expedited Data Received} The network transport returned partial data to its client and this data was marked as expedited by the remote system. The remaining data will be sent later.
  STATUS_EVENT_DONE = HRESULT($40000012);
  // {TDI Event Done} The TDI indication has completed successfully.
  STATUS_EVENT_PENDING = HRESULT($40000013);
  // {TDI Event Pending} The TDI indication has entered the pending state.
  STATUS_CHECKING_FILE_SYSTEM = HRESULT($40000014); // Checking file system on %wZ.
  STATUS_FATAL_APP_EXIT       = HRESULT($40000015); // {Fatal Application Exit} %hs
  STATUS_PREDEFINED_HANDLE    = HRESULT($40000016);
  // The specified registry key is referenced by a predefined handle.
  STATUS_WAS_UNLOCKED = HRESULT($40000017);
  // {Page Unlocked} The page protection of a locked page was changed to 'No Access' and the page was unlocked from memory and from the process.
  STATUS_SERVICE_NOTIFICATION = HRESULT($40000018); // %hs
  STATUS_WAS_LOCKED           = HRESULT($40000019);
  // {Page Locked} One of the pages to lock was already locked.
  STATUS_LOG_HARD_ERROR  = HRESULT($4000001A); // Application popup: %1 : %2
  STATUS_ALREADY_WIN32   = HRESULT($4000001B); // A Win32 process already exists.
  STATUS_WX86_UNSIMULATE = HRESULT($4000001C);
  // An exception status code that is used by the Win32 x86 emulation subsystem.
  STATUS_WX86_CONTINUE = HRESULT($4000001D);
  // An exception status code that is used by the Win32 x86 emulation subsystem.
  STATUS_WX86_SINGLE_STEP = HRESULT($4000001E);
  // An exception status code that is used by the Win32 x86 emulation subsystem.
  STATUS_WX86_BREAKPOINT = HRESULT($4000001F);
  // An exception status code that is used by the Win32 x86 emulation subsystem.
  STATUS_WX86_EXCEPTION_CONTINUE = HRESULT($40000020);
  // An exception status code that is used by the Win32 x86 emulation subsystem.
  STATUS_WX86_EXCEPTION_LASTCHANCE = HRESULT($40000021);
  // An exception status code that is used by the Win32 x86 emulation subsystem.
  STATUS_WX86_EXCEPTION_CHAIN = HRESULT($40000022);
  // An exception status code that is used by the Win32 x86 emulation subsystem.
  STATUS_IMAGE_MACHINE_TYPE_MISMATCH_EXE = HRESULT($40000023);
  // {Machine Type Mismatch} The image file %hs is valid but is for a machine type other than the current machine.
  STATUS_NO_YIELD_PERFORMED = HRESULT($40000024);
  // A yield execution was performed and no thread was available to run.
  STATUS_TIMER_RESUME_IGNORED = HRESULT($40000025);
  // The resume flag to a timer API was ignored.
  STATUS_ARBITRATION_UNHANDLED = HRESULT($40000026);
  // The arbiter has deferred arbitration of these resources to its parent.
  STATUS_CARDBUS_NOT_SUPPORTED = HRESULT($40000027);
  // The device has detected a CardBus card in its slot.
  STATUS_WX86_CREATEWX86TIB = HRESULT($40000028);
  // An exception status code that is used by the Win32 x86 emulation subsystem.
  STATUS_MP_PROCESSOR_MISMATCH = HRESULT($40000029);
  // The CPUs in this multiprocessor system are not all the same revision level. To use all processors, the operating system restricts itself to the features of the least capable processor in the system. If problems occur with this system, contact the CPU manufacturer to see if this mix of processors is supported.
  STATUS_HIBERNATED = HRESULT($4000002A); // The system was put into hibernation.
  STATUS_RESUME_HIBERNATION = HRESULT($4000002B);
  // The system was resumed from hibernation.
  STATUS_FIRMWARE_UPDATED = HRESULT($4000002C);
  // Windows has detected that the system firmware (BIOS) was updated [previous firmware date = %2, current firmware date %3].
  STATUS_DRIVERS_LEAKING_LOCKED_PAGES = HRESULT($4000002D);
  // A device driver is leaking locked I/O pages and is causing system degradation. The system has automatically enabled the tracking code to try and catch the culprit.
  STATUS_MESSAGE_RETRIEVED = HRESULT($4000002E);
  // The ALPC message being canceled has already been retrieved from the queue on the other side.
  STATUS_SYSTEM_POWERSTATE_TRANSITION = HRESULT($4000002F);
  // The system power state is transitioning from %2 to %3.
  STATUS_ALPC_CHECK_COMPLETION_LIST = HRESULT($40000030);
  // The receive operation was successful. Check the ALPC completion list for the received message.
  STATUS_SYSTEM_POWERSTATE_COMPLEX_TRANSITION = HRESULT($40000031);
  // The system power state is transitioning from %2 to %3 but could enter %4.
  STATUS_ACCESS_AUDIT_BY_POLICY = HRESULT($40000032);
  // Access to %1 is monitored by policy rule %2.
  STATUS_ABANDON_HIBERFILE = HRESULT($40000033);
  // A valid hibernation file has been invalidated and should be abandoned.
  STATUS_BIZRULES_NOT_ENABLED = HRESULT($40000034);
  // Business rule scripts are disabled for the calling application.
  STATUS_WAKE_SYSTEM      = HRESULT($40000294); // The system has awoken.
  STATUS_DS_SHUTTING_DOWN = HRESULT($40000370);
  // The directory service is shutting down.
  DBG_REPLY_LATER = HRESULT($40010001); // Debugger will reply later.
  DBG_UNABLE_TO_PROVIDE_HANDLE = HRESULT($40010002); // Debugger cannot provide a handle.
  DBG_TERMINATE_THREAD  = HRESULT($40010003); // Debugger terminated the thread.
  DBG_TERMINATE_PROCESS = HRESULT($40010004); // Debugger terminated the process.
  DBG_CONTROL_C         = HRESULT($40010005); // Debugger obtained control of C.
  DBG_PRINTEXCEPTION_C  = HRESULT($40010006);
  // Debugger printed an exception on control C.
  DBG_RIPEXCEPTION      = HRESULT($40010007); // Debugger received a RIP exception.
  DBG_CONTROL_BREAK     = HRESULT($40010008); // Debugger received a control break.
  DBG_COMMAND_EXCEPTION = HRESULT($40010009);
  // Debugger command communication exception.
  RPC_NT_UUID_LOCAL_ONLY = HRESULT($40020056);
  // A UUID that is valid only on this computer has been allocated.
  RPC_NT_SEND_INCOMPLETE = HRESULT($400200AF);
  // Some data remains to be sent in the request buffer.
  STATUS_CTX_CDM_CONNECT = HRESULT($400A0004);
  // The Client Drive Mapping Service has connected on Terminal Connection.
  STATUS_CTX_CDM_DISCONNECT = HRESULT($400A0005);
  // The Client Drive Mapping Service has disconnected on Terminal Connection.
  STATUS_SXS_RELEASE_ACTIVATION_CONTEXT = HRESULT($4015000D);
  // A kernel mode component is releasing a reference on an activation context.
  STATUS_RECOVERY_NOT_NEEDED = HRESULT($40190034);
  // The transactional resource manager is already consistent. Recovery is not needed.
  STATUS_RM_ALREADY_STARTED = HRESULT($40190035);
  // The transactional resource manager has already been started.
  STATUS_LOG_NO_RESTART = HRESULT($401A000C);
  // The log service encountered a log stream with no restart area.
  STATUS_VIDEO_DRIVER_DEBUG_REPORT_REQUEST = HRESULT($401B00EC);
  // {Display Driver Recovered From Failure} The %hs display driver has detected a failure and recovered from it. Some graphical operations might have failed. The next time you restart the machine, a dialog box appears, giving you an opportunity to upload data about this failure to Microsoft.
  STATUS_GRAPHICS_PARTIAL_DATA_POPULATED = HRESULT($401E000A);
  // The specified buffer is not big enough to contain the entire requested dataset. Partial data is populated up to the size of the buffer.  The caller needs to provide a buffer of the size as specified in the partially populated buffer's content (interface specific).
  STATUS_GRAPHICS_DRIVER_MISMATCH = HRESULT($401E0117);
  // The kernel driver detected a version mismatch between it and the user mode driver.
  STATUS_GRAPHICS_MODE_NOT_PINNED = HRESULT($401E0307);
  // No mode is pinned on the specified VidPN source/target.
  STATUS_GRAPHICS_NO_PREFERRED_MODE = HRESULT($401E031E);
  // The specified mode set does not specify a preference for one of its modes.
  STATUS_GRAPHICS_DATASET_IS_EMPTY = HRESULT($401E034B);
  // The specified dataset (for example, mode set, frequency range set, descriptor set, or topology) is empty.
  STATUS_GRAPHICS_NO_MORE_ELEMENTS_IN_DATASET = HRESULT($401E034C);
  // The specified dataset (for example, mode set, frequency range set, descriptor set, or topology) does not contain any more elements.
  STATUS_GRAPHICS_PATH_CONTENT_GEOMETRY_TRANSFORMATION_NOT_PINNED = HRESULT($401E0351);
  // The specified content transformation is not pinned on the specified VidPN present path.
  STATUS_GRAPHICS_UNKNOWN_CHILD_STATUS = HRESULT($401E042F);
  // The child device presence was not reliably detected.
  STATUS_GRAPHICS_LEADLINK_START_DEFERRED = HRESULT($401E0437);
  // Starting the lead adapter in a linked configuration has been temporarily deferred.
  STATUS_GRAPHICS_POLLING_TOO_FREQUENTLY = HRESULT($401E0439);
  // The display adapter is being polled for children too frequently at the same polling level.
  STATUS_GRAPHICS_START_DEFERRED = HRESULT($401E043A);
  // Starting the adapter has been temporarily deferred.
  STATUS_NDIS_INDICATION_REQUIRED = HRESULT($40230001);
  // The request will be completed later by an NDIS status indication.
  STATUS_GUARD_PAGE_VIOLATION = HRESULT($80000001);
  // {EXCEPTION} Guard Page Exception A page of memory that marks the end of a data structure, such as a stack or an array, has been accessed.
  STATUS_DATATYPE_MISALIGNMENT = HRESULT($80000002);
  // {EXCEPTION} Alignment Fault A data type misalignment was detected in a load or store instruction.
  STATUS_BREAKPOINT = HRESULT($80000003);
  // {EXCEPTION} Breakpoint A breakpoint has been reached.
  STATUS_SINGLE_STEP = HRESULT($80000004);
  // {EXCEPTION} Single Step A single step or trace operation has just been completed.
  STATUS_BUFFER_OVERFLOW = HRESULT($80000005);
  // {Buffer Overflow} The data was too large to fit into the specified buffer.
  STATUS_NO_MORE_FILES = HRESULT($80000006);
  // {No More Files} No more files were found which match the file specification.
  STATUS_WAKE_SYSTEM_DEBUGGER = HRESULT($80000007);
  // {Kernel Debugger Awakened} The system debugger was awakened by an interrupt.
  STATUS_HANDLES_CLOSED = HRESULT($8000000A);
  // {Handles Closed} Handles to objects have been automatically closed because of the requested operation.
  STATUS_NO_INHERITANCE = HRESULT($8000000B);
  // {Non-Inheritable ACL} An access control list (ACL) contains no components that can be inherited.
  STATUS_GUID_SUBSTITUTION_MADE = HRESULT($8000000C);
  // {GUID Substitution} During the translation of a globally unique identifier (GUID) to a Windows security ID (SID), no administratively defined GUID prefix was found. A substitute prefix was used, which will not compromise system security. However, this might provide a more restrictive access than intended.
  STATUS_PARTIAL_COPY = HRESULT($8000000D);
  // Because of protection conflicts, not all the requested bytes could be copied.
  STATUS_DEVICE_PAPER_EMPTY = HRESULT($8000000E);
  // {Out of Paper} The printer is out of paper.
  STATUS_DEVICE_POWERED_OFF = HRESULT($8000000F);
  // {Device Power Is Off} The printer power has been turned off.
  STATUS_DEVICE_OFF_LINE = HRESULT($80000010);
  // {Device Offline} The printer has been taken offline.
  STATUS_DEVICE_BUSY = HRESULT($80000011); // {Device Busy} The device is currently busy.
  STATUS_NO_MORE_EAS = HRESULT($80000012);
  // {No More EAs} No more extended attributes (EAs) were found for the file.
  STATUS_INVALID_EA_NAME = HRESULT($80000013);
  // {Illegal EA} The specified extended attribute (EA) name contains at least one illegal character.
  STATUS_EA_LIST_INCONSISTENT = HRESULT($80000014);
  // {Inconsistent EA List} The extended attribute (EA) list is inconsistent.
  STATUS_INVALID_EA_FLAG = HRESULT($80000015);
  // {Invalid EA Flag} An invalid extended attribute (EA) flag was set.
  STATUS_VERIFY_REQUIRED = HRESULT($80000016);
  // {Verifying Disk} The media has changed and a verify operation is in progress); therefore, no reads or writes can be performed to the device, except those that are used in the verify operation.
  STATUS_EXTRANEOUS_INFORMATION = HRESULT($80000017);
  // {Too Much Information} The specified access control list (ACL) contained more information than was expected.
  STATUS_RXACT_COMMIT_NECESSARY = HRESULT($80000018);
  // This warning level status indicates that the transaction state already exists for the registry subtree, but that a transaction commit was previously aborted. The commit has NOT been completed but has not been rolled back either); therefore, it can still be committed, if needed.
  STATUS_NO_MORE_ENTRIES = HRESULT($8000001A);
  // {No More Entries} No more entries are available from an enumeration operation.
  STATUS_FILEMARK_DETECTED = HRESULT($8000001B);
  // {Filemark Found} A filemark was detected.
  STATUS_MEDIA_CHANGED = HRESULT($8000001C); // {Media Changed} The media has changed.
  STATUS_BUS_RESET     = HRESULT($8000001D);
  // {I/O Bus Reset} An I/O bus reset was detected.
  STATUS_END_OF_MEDIA = HRESULT($8000001E);
  // {End of Media} The end of the media was encountered.
  STATUS_BEGINNING_OF_MEDIA = HRESULT($8000001F);
  // The beginning of a tape or partition has been detected.
  STATUS_MEDIA_CHECK = HRESULT($80000020);
  // {Media Changed} The media might have changed.
  STATUS_SETMARK_DETECTED = HRESULT($80000021); // A tape access reached a set mark.
  STATUS_NO_DATA_DETECTED = HRESULT($80000022);
  // During a tape access, the end of the data written is reached.
  STATUS_REDIRECTOR_HAS_OPEN_HANDLES = HRESULT($80000023);
  // The redirector is in use and cannot be unloaded.
  STATUS_SERVER_HAS_OPEN_HANDLES = HRESULT($80000024);
  // The server is in use and cannot be unloaded.
  STATUS_ALREADY_DISCONNECTED = HRESULT($80000025);
  // The specified connection has already been disconnected.
  STATUS_LONGJUMP = HRESULT($80000026); // A long jump has been executed.
  STATUS_CLEANER_CARTRIDGE_INSTALLED = HRESULT($80000027);
  // A cleaner cartridge is present in the tape library.
  STATUS_PLUGPLAY_QUERY_VETOED = HRESULT($80000028);
  // The Plug and Play query operation was not successful.
  STATUS_UNWIND_CONSOLIDATE = HRESULT($80000029);
  // A frame consolidation has been executed.
  STATUS_REGISTRY_HIVE_RECOVERED = HRESULT($8000002A);
  // {Registry Hive Recovered} The registry hive (file): %hs was corrupted and it has been recovered. Some data might have been lost.
  STATUS_DLL_MIGHT_BE_INSECURE = HRESULT($8000002B);
  // The application is attempting to run executable code from the module %hs. This might be insecure. An alternative, %hs, is available. Should the application use the secure module %hs?
  STATUS_DLL_MIGHT_BE_INCOMPATIBLE = HRESULT($8000002C);
  // The application is loading executable code from the module %hs. This is secure but might be incompatible with previous releases of the operating system. An alternative, %hs, is available. Should the application use the secure module %hs?
  STATUS_STOPPED_ON_SYMLINK = HRESULT($8000002D);
  // The create operation stopped after reaching a symbolic link.
  STATUS_DEVICE_REQUIRES_CLEANING = HRESULT($80000288);
  // The device has indicated that cleaning is necessary.
  STATUS_DEVICE_DOOR_OPEN = HRESULT($80000289);
  // The device has indicated that its door is open. Further operations require it closed and secured.
  STATUS_DATA_LOST_REPAIR = HRESULT($80000803);
  // Windows discovered a corruption in the file %hs. This file has now been repaired. Check if any data in the file was lost because of the corruption.
  DBG_EXCEPTION_NOT_HANDLED = HRESULT($80010001);
  // Debugger did not handle the exception.
  STATUS_CLUSTER_NODE_ALREADY_UP = HRESULT($80130001); // The cluster node is already up.
  STATUS_CLUSTER_NODE_ALREADY_DOWN = HRESULT($80130002);
  // The cluster node is already down.
  STATUS_CLUSTER_NETWORK_ALREADY_ONLINE = HRESULT($80130003);
  // The cluster network is already online.
  STATUS_CLUSTER_NETWORK_ALREADY_OFFLINE = HRESULT($80130004);
  // The cluster network is already offline.
  STATUS_CLUSTER_NODE_ALREADY_MEMBER = HRESULT($80130005);
  // The cluster node is already a member of the cluster.
  STATUS_COULD_NOT_RESIZE_LOG = HRESULT($80190009);
  // The log could not be set to the requested size.
  STATUS_NO_TXF_METADATA = HRESULT($80190029);
  // There is no transaction metadata on the file.
  STATUS_CANT_RECOVER_WITH_HANDLE_OPEN = HRESULT($80190031);
  // The file cannot be recovered because there is a handle still open on it.
  STATUS_TXF_METADATA_ALREADY_PRESENT = HRESULT($80190041);
  // Transaction metadata is already present on this file and cannot be superseded.
  STATUS_TRANSACTION_SCOPE_CALLBACKS_NOT_SET = HRESULT($80190042);
  // A transaction scope could not be entered because the scope handler has not been initialized.
  STATUS_VIDEO_HUNG_DISPLAY_DRIVER_THREAD_RECOVERED = HRESULT($801B00EB);
  // {Display Driver Stopped Responding and recovered} The %hs display driver has stopped working normally. The recovery had been performed.
  STATUS_FLT_BUFFER_TOO_SMALL = HRESULT($801C0001);
  // {Buffer too small} The buffer is too small to contain the entry. No information has been written to the buffer.
  STATUS_FVE_PARTIAL_METADATA = HRESULT($80210001);
  // Volume metadata read or write is incomplete.
  STATUS_FVE_TRANSIENT_STATE = HRESULT($80210002);
  // BitLocker encryption keys were ignored because the volume was in a transient state.
  STATUS_UNSUCCESSFUL = HRESULT($C0000001);
  // {Operation Failed} The requested operation was unsuccessful.
  STATUS_NOT_IMPLEMENTED = HRESULT($C0000002);
  // {Not Implemented} The requested operation is not implemented.
  STATUS_INVALID_INFO_CLASS = HRESULT($C0000003);
  // {Invalid Parameter} The specified information class is not a valid information class for the specified object.
  STATUS_INFO_LENGTH_MISMATCH = HRESULT($C0000004);
  // The specified information record length does not match the length that is required for the specified information class.
  STATUS_ACCESS_VIOLATION = HRESULT($C0000005);
  // The instruction at $%08lx referenced memory at $%08lx. The memory could not be %s.
  STATUS_IN_PAGE_ERROR = HRESULT($C0000006);
  // The instruction at $%08lx referenced memory at $%08lx. The required data was not placed into memory because of an I/O error status of $%08lx.
  STATUS_PAGEFILE_QUOTA = HRESULT($C0000007);
  // The page file quota for the process has been exhausted.
  STATUS_INVALID_HANDLE    = HRESULT($C0000008); // An invalid HANDLE was specified.
  STATUS_BAD_INITIAL_STACK = HRESULT($C0000009);
  // An invalid initial stack was specified in a call to NtCreateThread.
  STATUS_BAD_INITIAL_PC = HRESULT($C000000A);
  // An invalid initial start address was specified in a call to NtCreateThread.
  STATUS_INVALID_CID        = HRESULT($C000000B); // An invalid client ID was specified.
  STATUS_TIMER_NOT_CANCELED = HRESULT($C000000C);
  // An attempt was made to cancel or set a timer that has an associated APC and the specified thread is not the thread that originally set the timer with an associated APC routine.
  STATUS_INVALID_PARAMETER = HRESULT($C000000D);
  // An invalid parameter was passed to a service or function.
  STATUS_NO_SUCH_DEVICE = HRESULT($C000000E);
  // A device that does not exist was specified.
  STATUS_NO_SUCH_FILE = HRESULT($C000000F);
  // {File Not Found} The file %hs does not exist.
  STATUS_INVALID_DEVICE_REQUEST = HRESULT($C0000010);
  // The specified request is not a valid operation for the target device.
  STATUS_END_OF_FILE = HRESULT($C0000011);
  // The end-of-file marker has been reached. There is no valid data in the file beyond this marker.
  STATUS_WRONG_VOLUME = HRESULT($C0000012);
  // {Wrong Volume} The wrong volume is in the drive. Insert volume %hs into drive %hs.
  STATUS_NO_MEDIA_IN_DEVICE = HRESULT($C0000013);
  // {No Disk} There is no disk in the drive. Insert a disk into drive %hs.
  STATUS_UNRECOGNIZED_MEDIA = HRESULT($C0000014);
  // {Unknown Disk Format} The disk in drive %hs is not formatted properly. Check the disk, and reformat it, if needed.
  STATUS_NONEXISTENT_SECTOR = HRESULT($C0000015);
  // {Sector Not Found} The specified sector does not exist.
  STATUS_MORE_PROCESSING_REQUIRED = HRESULT($C0000016);
  // {Still Busy} The specified I/O request packet (IRP) cannot be disposed of because the I/O operation is not complete.
  STATUS_NO_MEMORY = HRESULT($C0000017);
  // {Not Enough Quota} Not enough virtual memory or paging file quota is available to complete the specified operation.
  STATUS_CONFLICTING_ADDRESSES = HRESULT($C0000018);
  // {Conflicting Address Range} The specified address range conflicts with the address space.
  STATUS_NOT_MAPPED_VIEW = HRESULT($C0000019);
  // The address range to unmap is not a mapped view.
  STATUS_UNABLE_TO_FREE_VM = HRESULT($C000001A); // The virtual memory cannot be freed.
  STATUS_UNABLE_TO_DELETE_SECTION = HRESULT($C000001B);
  // The specified section cannot be deleted.
  STATUS_INVALID_SYSTEM_SERVICE = HRESULT($C000001C);
  // An invalid system service was specified in a system service call.
  STATUS_ILLEGAL_INSTRUCTION = HRESULT($C000001D);
  // {EXCEPTION} Illegal Instruction An attempt was made to execute an illegal instruction.
  STATUS_INVALID_LOCK_SEQUENCE = HRESULT($C000001E);
  // {Invalid Lock Sequence} An attempt was made to execute an invalid lock sequence.
  STATUS_INVALID_VIEW_SIZE = HRESULT($C000001F);
  // {Invalid Mapping} An attempt was made to create a view for a section that is bigger than the section.
  STATUS_INVALID_FILE_FOR_SECTION = HRESULT($C0000020);
  // {Bad File} The attributes of the specified mapping file for a section of memory cannot be read.
  STATUS_ALREADY_COMMITTED = HRESULT($C0000021);
  // {Already Committed} The specified address range is already committed.
  STATUS_ACCESS_DENIED = HRESULT($C0000022);
  // {Access Denied} A process has requested access to an object but has not been granted those access rights.
  STATUS_BUFFER_TOO_SMALL = HRESULT($C0000023);
  // {Buffer Too Small} The buffer is too small to contain the entry. No information has been written to the buffer.
  STATUS_OBJECT_TYPE_MISMATCH = HRESULT($C0000024);
  // {Wrong Type} There is a mismatch between the type of object that is required by the requested operation and the type of object that is specified in the request.
  STATUS_NONCONTINUABLE_EXCEPTION = HRESULT($C0000025);
  // {EXCEPTION} Cannot Continue Windows cannot continue from this exception.
  STATUS_INVALID_DISPOSITION = HRESULT($C0000026);
  // An invalid exception disposition was returned by an exception handler.
  STATUS_UNWIND    = HRESULT($C0000027); // Unwind exception code.
  STATUS_BAD_STACK = HRESULT($C0000028);
  // An invalid or unaligned stack was encountered during an unwind operation.
  STATUS_INVALID_UNWIND_TARGET = HRESULT($C0000029);
  // An invalid unwind target was encountered during an unwind operation.
  STATUS_NOT_LOCKED = HRESULT($C000002A);
  // An attempt was made to unlock a page of memory that was not locked.
  STATUS_PARITY_ERROR = HRESULT($C000002B); // A device parity error on an I/O operation.
  STATUS_UNABLE_TO_DECOMMIT_VM = HRESULT($C000002C);
  // An attempt was made to decommit uncommitted virtual memory.
  STATUS_NOT_COMMITTED = HRESULT($C000002D);
  // An attempt was made to change the attributes on memory that has not been committed.
  STATUS_INVALID_PORT_ATTRIBUTES = HRESULT($C000002E);
  // Invalid object attributes specified to NtCreatePort or invalid port attributes specified to NtConnectPort.
  STATUS_PORT_MESSAGE_TOO_LONG = HRESULT($C000002F);
  // The length of the message that was passed to NtRequestPort or NtRequestWaitReplyPort is longer than the maximum message that is allowed by the port.
  STATUS_INVALID_PARAMETER_MIX = HRESULT($C0000030);
  // An invalid combination of parameters was specified.
  STATUS_INVALID_QUOTA_LOWER = HRESULT($C0000031);
  // An attempt was made to lower a quota limit below the current usage.
  STATUS_DISK_CORRUPT_ERROR = HRESULT($C0000032);
  // {Corrupt Disk} The file system structure on the disk is corrupt and unusable. Run the Chkdsk utility on the volume %hs.
  STATUS_OBJECT_NAME_INVALID   = HRESULT($C0000033); // The object name is invalid.
  STATUS_OBJECT_NAME_NOT_FOUND = HRESULT($C0000034); // The object name is not found.
  STATUS_OBJECT_NAME_COLLISION = HRESULT($C0000035); // The object name already exists.
  STATUS_PORT_DISCONNECTED     = HRESULT($C0000037);
  // An attempt was made to send a message to a disconnected communication port.
  STATUS_DEVICE_ALREADY_ATTACHED = HRESULT($C0000038);
  // An attempt was made to attach to a device that was already attached to another device.
  STATUS_OBJECT_PATH_INVALID = HRESULT($C0000039);
  // The object path component was not a directory object.
  STATUS_OBJECT_PATH_NOT_FOUND = HRESULT($C000003A);
  // {Path Not Found} The path %hs does not exist.
  STATUS_OBJECT_PATH_SYNTAX_BAD = HRESULT($C000003B);
  // The object path component was not a directory object.
  STATUS_DATA_OVERRUN = HRESULT($C000003C);
  // {Data Overrun} A data overrun error occurred.
  STATUS_DATA_LATE_ERROR = HRESULT($C000003D); // {Data Late} A data late error occurred.
  STATUS_DATA_ERROR = HRESULT($C000003E);
  // {Data Error} An error occurred in reading or writing data.
  STATUS_CRC_ERROR = HRESULT($C000003F);
  // {Bad CRC} A cyclic redundancy check (CRC) checksum error occurred.
  STATUS_SECTION_TOO_BIG = HRESULT($C0000040);
  // {Section Too Large} The specified section is too big to map the file.
  STATUS_PORT_CONNECTION_REFUSED = HRESULT($C0000041);
  // The NtConnectPort request is refused.
  STATUS_INVALID_PORT_HANDLE = HRESULT($C0000042);
  // The type of port handle is invalid for the operation that is requested.
  STATUS_SHARING_VIOLATION = HRESULT($C0000043);
  // A file cannot be opened because the share access flags are incompatible.
  STATUS_QUOTA_EXCEEDED = HRESULT($C0000044);
  // Insufficient quota exists to complete the operation.
  STATUS_INVALID_PAGE_PROTECTION = HRESULT($C0000045);
  // The specified page protection was not valid.
  STATUS_MUTANT_NOT_OWNED = HRESULT($C0000046);
  // An attempt to release a mutant object was made by a thread that was not the owner of the mutant object.
  STATUS_SEMAPHORE_LIMIT_EXCEEDED = HRESULT($C0000047);
  // An attempt was made to release a semaphore such that its maximum count would have been exceeded.
  STATUS_PORT_ALREADY_SET = HRESULT($C0000048);
  // An attempt was made to set the DebugPort or ExceptionPort of a process, but a port already exists in the process, or an attempt was made to set the CompletionPort of a file but a port was already set in the file, or an attempt was made to set the associated completion port of an ALPC port but it is already set.
  STATUS_SECTION_NOT_IMAGE = HRESULT($C0000049);
  // An attempt was made to query image information on a section that does not map an image.
  STATUS_SUSPEND_COUNT_EXCEEDED = HRESULT($C000004A);
  // An attempt was made to suspend a thread whose suspend count was at its maximum.
  STATUS_THREAD_IS_TERMINATING = HRESULT($C000004B);
  // An attempt was made to suspend a thread that has begun termination.
  STATUS_BAD_WORKING_SET_LIMIT = HRESULT($C000004C);
  // An attempt was made to set the working set limit to an invalid value (for example, the minimum greater than maximum).
  STATUS_INCOMPATIBLE_FILE_MAP = HRESULT($C000004D);
  // A section was created to map a file that is not compatible with an already existing section that maps the same file.
  STATUS_SECTION_PROTECTION = HRESULT($C000004E);
  // A view to a section specifies a protection that is incompatible with the protection of the initial view.
  STATUS_EAS_NOT_SUPPORTED = HRESULT($C000004F);
  // An operation involving EAs failed because the file system does not support EAs.
  STATUS_EA_TOO_LARGE = HRESULT($C0000050);
  // An EA operation failed because the EA set is too large.
  STATUS_NONEXISTENT_EA_ENTRY = HRESULT($C0000051);
  // An EA operation failed because the name or EA index is invalid.
  STATUS_NO_EAS_ON_FILE = HRESULT($C0000052);
  // The file for which EAs were requested has no EAs.
  STATUS_EA_CORRUPT_ERROR = HRESULT($C0000053); // The EA is corrupt and cannot be read.
  STATUS_FILE_LOCK_CONFLICT = HRESULT($C0000054);
  // A requested read/write cannot be granted due to a conflicting file lock.
  STATUS_LOCK_NOT_GRANTED = HRESULT($C0000055);
  // A requested file lock cannot be granted due to other existing locks.
  STATUS_DELETE_PENDING = HRESULT($C0000056);
  // A non-close operation has been requested of a file object that has a delete pending.
  STATUS_CTL_FILE_NOT_SUPPORTED = HRESULT($C0000057);
  // An attempt was made to set the control attribute on a file. This attribute is not supported in the destination file system.
  STATUS_UNKNOWN_REVISION = HRESULT($C0000058);
  // Indicates a revision number that was encountered or specified is not one that is known by the service. It might be a more recent revision than the service is aware of.
  STATUS_REVISION_MISMATCH = HRESULT($C0000059);
  // Indicates that two revision levels are incompatible.
  STATUS_INVALID_OWNER = HRESULT($C000005A);
  // Indicates a particular security ID cannot be assigned as the owner of an object.
  STATUS_INVALID_PRIMARY_GROUP = HRESULT($C000005B);
  // Indicates a particular security ID cannot be assigned as the primary group of an object.
  STATUS_NO_IMPERSONATION_TOKEN = HRESULT($C000005C);
  // An attempt has been made to operate on an impersonation token by a thread that is not currently impersonating a client.
  STATUS_CANT_DISABLE_MANDATORY = HRESULT($C000005D);
  // A mandatory group cannot be disabled.
  STATUS_NO_LOGON_SERVERS = HRESULT($C000005E);
  // No logon servers are currently available to service the logon request.
  STATUS_NO_SUCH_LOGON_SESSION = HRESULT($C000005F);
  // A specified logon session does not exist. It might already have been terminated.
  STATUS_NO_SUCH_PRIVILEGE = HRESULT($C0000060); // A specified privilege does not exist.
  STATUS_PRIVILEGE_NOT_HELD = HRESULT($C0000061);
  // A required privilege is not held by the client.
  STATUS_INVALID_ACCOUNT_NAME = HRESULT($C0000062);
  // The name provided is not a properly formed account name.
  STATUS_USER_EXISTS     = HRESULT($C0000063); // The specified account already exists.
  STATUS_NO_SUCH_USER    = HRESULT($C0000064); // The specified account does not exist.
  STATUS_GROUP_EXISTS    = HRESULT($C0000065); // The specified group already exists.
  STATUS_NO_SUCH_GROUP   = HRESULT($C0000066); // The specified group does not exist.
  STATUS_MEMBER_IN_GROUP = HRESULT($C0000067);
  // The specified user account is already in the specified group account. Also used to indicate a group cannot be deleted because it contains a member.
  STATUS_MEMBER_NOT_IN_GROUP = HRESULT($C0000068);
  // The specified user account is not a member of the specified group account.
  STATUS_LAST_ADMIN = HRESULT($C0000069);
  // Indicates the requested operation would disable or delete the last remaining administration account. This is not allowed to prevent creating a situation in which the system cannot be administrated.
  STATUS_WRONG_PASSWORD = HRESULT($C000006A);
  // When trying to update a password, this return status indicates that the value provided as the current password is not correct.
  STATUS_ILL_FORMED_PASSWORD = HRESULT($C000006B);
  // When trying to update a password, this return status indicates that the value provided for the new password contains values that are not allowed in passwords.
  STATUS_PASSWORD_RESTRICTION = HRESULT($C000006C);
  // When trying to update a password, this status indicates that some password update rule has been violated. For example, the password might not meet length criteria.
  STATUS_LOGON_FAILURE = HRESULT($C000006D);
  // The attempted logon is invalid. This is either due to a bad username or authentication information.
  STATUS_ACCOUNT_RESTRICTION = HRESULT($C000006E);
  // Indicates a referenced user name and authentication information are valid, but some user account restriction has prevented successful authentication (such as time-of-day restrictions).
  STATUS_INVALID_LOGON_HOURS = HRESULT($C000006F);
  // The user account has time restrictions and cannot be logged onto at this time.
  STATUS_INVALID_WORKSTATION = HRESULT($C0000070);
  // The user account is restricted so that it cannot be used to log on from the source workstation.
  STATUS_PASSWORD_EXPIRED = HRESULT($C0000071); // The user account password has expired.
  STATUS_ACCOUNT_DISABLED = HRESULT($C0000072);
  // The referenced account is currently disabled and cannot be logged on to.
  STATUS_NONE_MAPPED = HRESULT($C0000073);
  // None of the information to be translated has been translated.
  STATUS_TOO_MANY_LUIDS_REQUESTED = HRESULT($C0000074);
  // The number of LUIDs requested cannot be allocated with a single allocation.
  STATUS_LUIDS_EXHAUSTED = HRESULT($C0000075);
  // Indicates there are no more LUIDs to allocate.
  STATUS_INVALID_SUB_AUTHORITY = HRESULT($C0000076);
  // Indicates the sub-authority value is invalid for the particular use.
  STATUS_INVALID_ACL = HRESULT($C0000077); // Indicates the ACL structure is not valid.
  STATUS_INVALID_SID = HRESULT($C0000078); // Indicates the SID structure is not valid.
  STATUS_INVALID_SECURITY_DESCR = HRESULT($C0000079);
  // Indicates the SECURITY_DESCRIPTOR structure is not valid.
  STATUS_PROCEDURE_NOT_FOUND = HRESULT($C000007A);
  // Indicates the specified procedure address cannot be found in the DLL.
  STATUS_INVALID_IMAGE_FORMAT = HRESULT($C000007B);
  // {Bad Image} %hs is either not designed to run on Windows or it contains an error. Try installing the program again using the original installation media or contact your system administrator or the software vendor for support.
  STATUS_NO_TOKEN = HRESULT($C000007C);
  // An attempt was made to reference a token that does not exist. This is typically done by referencing the token that is associated with a thread when the thread is not impersonating a client.
  STATUS_BAD_INHERITANCE_ACL = HRESULT($C000007D);
  // Indicates that an attempt to build either an inherited ACL or ACE was not successful. This can be caused by a number of things. One of the more probable causes is the replacement of a CreatorId with a SID that did not fit into the ACE or ACL.
  STATUS_RANGE_NOT_LOCKED = HRESULT($C000007E);
  // The range specified in NtUnlockFile was not locked.
  STATUS_DISK_FULL = HRESULT($C000007F);
  // An operation failed because the disk was full.
  STATUS_SERVER_DISABLED = HRESULT($C0000080);
  // The GUID allocation server is disabled at the moment.
  STATUS_SERVER_NOT_DISABLED = HRESULT($C0000081);
  // The GUID allocation server is enabled at the moment.
  STATUS_TOO_MANY_GUIDS_REQUESTED = HRESULT($C0000082);
  // Too many GUIDs were requested from the allocation server at once.
  STATUS_GUIDS_EXHAUSTED = HRESULT($C0000083);
  // The GUIDs could not be allocated because the Authority Agent was exhausted.
  STATUS_INVALID_ID_AUTHORITY = HRESULT($C0000084);
  // The value provided was an invalid value for an identifier authority.
  STATUS_AGENTS_EXHAUSTED = HRESULT($C0000085);
  // No more authority agent values are available for the particular identifier authority value.
  STATUS_INVALID_VOLUME_LABEL = HRESULT($C0000086);
  // An invalid volume label has been specified.
  STATUS_SECTION_NOT_EXTENDED = HRESULT($C0000087);
  // A mapped section could not be extended.
  STATUS_NOT_MAPPED_DATA = HRESULT($C0000088);
  // Specified section to flush does not map a data file.
  STATUS_RESOURCE_DATA_NOT_FOUND = HRESULT($C0000089);
  // Indicates the specified image file did not contain a resource section.
  STATUS_RESOURCE_TYPE_NOT_FOUND = HRESULT($C000008A);
  // Indicates the specified resource type cannot be found in the image file.
  STATUS_RESOURCE_NAME_NOT_FOUND = HRESULT($C000008B);
  // Indicates the specified resource name cannot be found in the image file.
  STATUS_ARRAY_BOUNDS_EXCEEDED = HRESULT($C000008C);
  // {EXCEPTION} Array bounds exceeded.
  STATUS_FLOAT_DENORMAL_OPERAND = HRESULT($C000008D);
  // {EXCEPTION} Floating-point denormal operand.
  STATUS_FLOAT_DIVIDE_BY_ZERO = HRESULT($C000008E);
  // {EXCEPTION} Floating-point division by zero.
  STATUS_FLOAT_INEXACT_RESULT = HRESULT($C000008F);
  // {EXCEPTION} Floating-point inexact result.
  STATUS_FLOAT_INVALID_OPERATION = HRESULT($C0000090);
  // {EXCEPTION} Floating-point invalid operation.
  STATUS_FLOAT_OVERFLOW    = HRESULT($C0000091); // {EXCEPTION} Floating-point overflow.
  STATUS_FLOAT_STACK_CHECK = HRESULT($C0000092);
  // {EXCEPTION} Floating-point stack check.
  STATUS_FLOAT_UNDERFLOW = HRESULT($C0000093); // {EXCEPTION} Floating-point underflow.
  STATUS_INTEGER_DIVIDE_BY_ZERO = HRESULT($C0000094);
  // {EXCEPTION} Integer division by zero.
  STATUS_INTEGER_OVERFLOW       = HRESULT($C0000095); // {EXCEPTION} Integer overflow.
  STATUS_PRIVILEGED_INSTRUCTION = HRESULT($C0000096);
  // {EXCEPTION} Privileged instruction.
  STATUS_TOO_MANY_PAGING_FILES = HRESULT($C0000097);
  // An attempt was made to install more paging files than the system supports.
  STATUS_FILE_INVALID = HRESULT($C0000098);
  // The volume for a file has been externally altered such that the opened file is no longer valid.
  STATUS_ALLOTTED_SPACE_EXCEEDED = HRESULT($C0000099);
  // When a block of memory is allotted for future updates, such as the memory allocated to hold discretionary access control and primary group information, successive updates might exceed the amount of memory originally allotted. Because a quota might already have been charged to several processes that have handles to the object, it is not reasonable to alter the size of the allocated memory. Instead, a request that requires more memory than has been allotted must fail and the STATUS_ALLOTTED_SPACE_EXCEEDED error returned.
  STATUS_INSUFFICIENT_RESOURCES = HRESULT($C000009A);
  // Insufficient system resources exist to complete the API.
  STATUS_DFS_EXIT_PATH_FOUND = HRESULT($C000009B);
  // An attempt has been made to open a DFS exit path control file.
  STATUS_DEVICE_DATA_ERROR = HRESULT($C000009C);
  // There are bad blocks (sectors) on the hard disk.
  STATUS_DEVICE_NOT_CONNECTED = HRESULT($C000009D);
  // There is bad cabling, non-termination, or the controller is not able to obtain access to the hard disk.
  STATUS_FREE_VM_NOT_AT_BASE = HRESULT($C000009F);
  // Virtual memory cannot be freed because the base address is not the base of the region and a region size of zero was specified.
  STATUS_MEMORY_NOT_ALLOCATED = HRESULT($C00000A0);
  // An attempt was made to free virtual memory that is not allocated.
  STATUS_WORKING_SET_QUOTA = HRESULT($C00000A1);
  // The working set is not big enough to allow the requested pages to be locked.
  STATUS_MEDIA_WRITE_PROTECTED = HRESULT($C00000A2);
  // {Write Protect Error} The disk cannot be written to because it is write-protected. Remove the write protection from the volume %hs in drive %hs.
  STATUS_DEVICE_NOT_READY = HRESULT($C00000A3);
  // {Drive Not Ready} The drive is not ready for use); its door might be open. Check drive %hs and make sure that a disk is inserted and that the drive door is closed.
  STATUS_INVALID_GROUP_ATTRIBUTES = HRESULT($C00000A4);
  // The specified attributes are invalid or are incompatible with the attributes for the group as a whole.
  STATUS_BAD_IMPERSONATION_LEVEL = HRESULT($C00000A5);
  // A specified impersonation level is invalid. Also used to indicate that a required impersonation level was not provided.
  STATUS_CANT_OPEN_ANONYMOUS = HRESULT($C00000A6);
  // An attempt was made to open an anonymous-level token. Anonymous tokens cannot be opened.
  STATUS_BAD_VALIDATION_CLASS = HRESULT($C00000A7);
  // The validation information class requested was invalid.
  STATUS_BAD_TOKEN_TYPE = HRESULT($C00000A8);
  // The type of a token object is inappropriate for its attempted use.
  STATUS_BAD_MASTER_BOOT_RECORD = HRESULT($C00000A9);
  // The type of a token object is inappropriate for its attempted use.
  STATUS_INSTRUCTION_MISALIGNMENT = HRESULT($C00000AA);
  // An attempt was made to execute an instruction at an unaligned address and the host system does not support unaligned instruction references.
  STATUS_INSTANCE_NOT_AVAILABLE = HRESULT($C00000AB);
  // The maximum named pipe instance count has been reached.
  STATUS_PIPE_NOT_AVAILABLE = HRESULT($C00000AC);
  // An instance of a named pipe cannot be found in the listening state.
  STATUS_INVALID_PIPE_STATE = HRESULT($C00000AD);
  // The named pipe is not in the connected or closing state.
  STATUS_PIPE_BUSY = HRESULT($C00000AE);
  // The specified pipe is set to complete operations and there are current I/O operations queued so that it cannot be changed to queue operations.
  STATUS_ILLEGAL_FUNCTION = HRESULT($C00000AF);
  // The specified handle is not open to the server end of the named pipe.
  STATUS_PIPE_DISCONNECTED = HRESULT($C00000B0);
  // The specified named pipe is in the disconnected state.
  STATUS_PIPE_CLOSING = HRESULT($C00000B1);
  // The specified named pipe is in the closing state.
  STATUS_PIPE_CONNECTED = HRESULT($C00000B2);
  // The specified named pipe is in the connected state.
  STATUS_PIPE_LISTENING = HRESULT($C00000B3);
  // The specified named pipe is in the listening state.
  STATUS_INVALID_READ_MODE = HRESULT($C00000B4);
  // The specified named pipe is not in message mode.
  STATUS_IO_TIMEOUT = HRESULT($C00000B5);
  // {Device Timeout} The specified I/O operation on %hs was not completed before the time-out period expired.
  STATUS_FILE_FORCED_CLOSED = HRESULT($C00000B6);
  // The specified file has been closed by another process.
  STATUS_PROFILING_NOT_STARTED = HRESULT($C00000B7); // Profiling is not started.
  STATUS_PROFILING_NOT_STOPPED = HRESULT($C00000B8); // Profiling is not stopped.
  STATUS_COULD_NOT_INTERPRET   = HRESULT($C00000B9);
  // The passed ACL did not contain the minimum required information.
  STATUS_FILE_IS_A_DIRECTORY = HRESULT($C00000BA);
  // The file that was specified as a target is a directory, and the caller specified that it could be anything but a directory.
  STATUS_NOT_SUPPORTED        = HRESULT($C00000BB); // The request is not supported.
  STATUS_REMOTE_NOT_LISTENING = HRESULT($C00000BC);
  // This remote computer is not listening.
  STATUS_DUPLICATE_NAME = HRESULT($C00000BD); // A duplicate name exists on the network.
  STATUS_BAD_NETWORK_PATH = HRESULT($C00000BE); // The network path cannot be located.
  STATUS_NETWORK_BUSY          = HRESULT($C00000BF); // The network is busy.
  STATUS_DEVICE_DOES_NOT_EXIST = HRESULT($C00000C0); // This device does not exist.
  STATUS_TOO_MANY_COMMANDS     = HRESULT($C00000C1);
  // The network BIOS command limit has been reached.
  STATUS_ADAPTER_HARDWARE_ERROR = HRESULT($C00000C2);
  // An I/O adapter hardware error has occurred.
  STATUS_INVALID_NETWORK_RESPONSE = HRESULT($C00000C3);
  // The network responded incorrectly.
  STATUS_UNEXPECTED_NETWORK_ERROR = HRESULT($C00000C4);
  // An unexpected network error occurred.
  STATUS_BAD_REMOTE_ADAPTER = HRESULT($C00000C5);
  // The remote adapter is not compatible.
  STATUS_PRINT_QUEUE_FULL = HRESULT($C00000C6); // The print queue is full.
  STATUS_NO_SPOOL_SPACE   = HRESULT($C00000C7);
  // Space to store the file that is waiting to be printed is not available on the server.
  STATUS_PRINT_CANCELLED = HRESULT($C00000C8);
  // The requested print file has been canceled.
  STATUS_NETWORK_NAME_DELETED  = HRESULT($C00000C9); // The network name was deleted.
  STATUS_NETWORK_ACCESS_DENIED = HRESULT($C00000CA); // Network access is denied.
  STATUS_BAD_DEVICE_TYPE       = HRESULT($C00000CB);
  // {Incorrect Network Resource Type} The specified device type (LPT, for example) conflicts with the actual device type on the remote resource.
  STATUS_BAD_NETWORK_NAME = HRESULT($C00000CC);
  // {Network Name Not Found} The specified share name cannot be found on the remote server.
  STATUS_TOO_MANY_NAMES = HRESULT($C00000CD);
  // The name limit for the network adapter card of the local computer was exceeded.
  STATUS_TOO_MANY_SESSIONS = HRESULT($C00000CE);
  // The network BIOS session limit was exceeded.
  STATUS_SHARING_PAUSED = HRESULT($C00000CF);
  // File sharing has been temporarily paused.
  STATUS_REQUEST_NOT_ACCEPTED = HRESULT($C00000D0);
  // No more connections can be made to this remote computer at this time because the computer has already accepted the maximum number of connections.
  STATUS_REDIRECTOR_PAUSED = HRESULT($C00000D1);
  // Print or disk redirection is temporarily paused.
  STATUS_NET_WRITE_FAULT    = HRESULT($C00000D2); // A network data fault occurred.
  STATUS_PROFILING_AT_LIMIT = HRESULT($C00000D3);
  // The number of active profiling objects is at the maximum and no more can be started.
  STATUS_NOT_SAME_DEVICE = HRESULT($C00000D4);
  // {Incorrect Volume} The destination file of a rename request is located on a different device than the source of the rename request.
  STATUS_FILE_RENAMED = HRESULT($C00000D5);
  // The specified file has been renamed and thus cannot be modified.
  STATUS_VIRTUAL_CIRCUIT_CLOSED = HRESULT($C00000D6);
  // {Network Request Timeout} The session with a remote server has been disconnected because the time-out interval for a request has expired.
  STATUS_NO_SECURITY_ON_OBJECT = HRESULT($C00000D7);
  // Indicates an attempt was made to operate on the security of an object that does not have security associated with it.
  STATUS_CANT_WAIT = HRESULT($C00000D8);
  // Used to indicate that an operation cannot continue without blocking for I/O.
  STATUS_PIPE_EMPTY = HRESULT($C00000D9);
  // Used to indicate that a read operation was done on an empty pipe.
  STATUS_CANT_ACCESS_DOMAIN_INFO = HRESULT($C00000DA);
  // Configuration information could not be read from the domain controller, either because the machine is unavailable or access has been denied.
  STATUS_CANT_TERMINATE_SELF = HRESULT($C00000DB);
  // Indicates that a thread attempted to terminate itself by default (called NtTerminateThread with NULL) and it was the last thread in the current process.
  STATUS_INVALID_SERVER_STATE = HRESULT($C00000DC);
  // Indicates the Sam Server was in the wrong state to perform the desired operation.
  STATUS_INVALID_DOMAIN_STATE = HRESULT($C00000DD);
  // Indicates the domain was in the wrong state to perform the desired operation.
  STATUS_INVALID_DOMAIN_ROLE = HRESULT($C00000DE);
  // This operation is only allowed for the primary domain controller of the domain.
  STATUS_NO_SUCH_DOMAIN = HRESULT($C00000DF); // The specified domain did not exist.
  STATUS_DOMAIN_EXISTS  = HRESULT($C00000E0); // The specified domain already exists.
  STATUS_DOMAIN_LIMIT_EXCEEDED = HRESULT($C00000E1);
  // An attempt was made to exceed the limit on the number of domains per server for this release.
  STATUS_OPLOCK_NOT_GRANTED = HRESULT($C00000E2);
  // An error status returned when the opportunistic lock (oplock) request is denied.
  STATUS_INVALID_OPLOCK_PROTOCOL = HRESULT($C00000E3);
  // An error status returned when an invalid opportunistic lock (oplock) acknowledgment is received by a file system.
  STATUS_INTERNAL_DB_CORRUPTION = HRESULT($C00000E4);
  // This error indicates that the requested operation cannot be completed due to a catastrophic media failure or an on-disk data structure corruption.
  STATUS_INTERNAL_ERROR     = HRESULT($C00000E5); // An internal error occurred.
  STATUS_GENERIC_NOT_MAPPED = HRESULT($C00000E6);
  // Indicates generic access types were contained in an access mask which should already be mapped to non-generic access types.
  STATUS_BAD_DESCRIPTOR_FORMAT = HRESULT($C00000E7);
  // Indicates a security descriptor is not in the necessary format (absolute or self-relative).
  STATUS_INVALID_USER_BUFFER = HRESULT($C00000E8);
  // An access to a user buffer failed at an expected point in time. This code is defined because the caller does not want to accept STATUS_ACCESS_VIOLATION in its filter.
  STATUS_UNEXPECTED_IO_ERROR = HRESULT($C00000E9);
  // If an I/O error that is not defined in the standard FsRtl filter is returned, it is converted to the following error, which is guaranteed to be in the filter. In this case, information is lost); however, the filter correctly handles the exception.
  STATUS_UNEXPECTED_MM_CREATE_ERR = HRESULT($C00000EA);
  // If an MM error that is not defined in the standard FsRtl filter is returned, it is converted to one of the following errors, which are guaranteed to be in the filter. In this case, information is lost); however, the filter correctly handles the exception.
  STATUS_UNEXPECTED_MM_MAP_ERROR = HRESULT($C00000EB);
  // If an MM error that is not defined in the standard FsRtl filter is returned, it is converted to one of the following errors, which are guaranteed to be in the filter. In this case, information is lost); however, the filter correctly handles the exception.
  STATUS_UNEXPECTED_MM_EXTEND_ERR = HRESULT($C00000EC);
  // If an MM error that is not defined in the standard FsRtl filter is returned, it is converted to one of the following errors, which are guaranteed to be in the filter. In this case, information is lost); however, the filter correctly handles the exception.
  STATUS_NOT_LOGON_PROCESS = HRESULT($C00000ED);
  // The requested action is restricted for use by logon processes only. The calling process has not registered as a logon process.
  STATUS_LOGON_SESSION_EXISTS = HRESULT($C00000EE);
  // An attempt has been made to start a new session manager or LSA logon session by using an ID that is already in use.
  STATUS_INVALID_PARAMETER_1 = HRESULT($C00000EF);
  // An invalid parameter was passed to a service or function as the first argument.
  STATUS_INVALID_PARAMETER_2 = HRESULT($C00000F0);
  // An invalid parameter was passed to a service or function as the second argument.
  STATUS_INVALID_PARAMETER_3 = HRESULT($C00000F1);
  // An invalid parameter was passed to a service or function as the third argument.
  STATUS_INVALID_PARAMETER_4 = HRESULT($C00000F2);
  // An invalid parameter was passed to a service or function as the fourth argument.
  STATUS_INVALID_PARAMETER_5 = HRESULT($C00000F3);
  // An invalid parameter was passed to a service or function as the fifth argument.
  STATUS_INVALID_PARAMETER_6 = HRESULT($C00000F4);
  // An invalid parameter was passed to a service or function as the sixth argument.
  STATUS_INVALID_PARAMETER_7 = HRESULT($C00000F5);
  // An invalid parameter was passed to a service or function as the seventh argument.
  STATUS_INVALID_PARAMETER_8 = HRESULT($C00000F6);
  // An invalid parameter was passed to a service or function as the eighth argument.
  STATUS_INVALID_PARAMETER_9 = HRESULT($C00000F7);
  // An invalid parameter was passed to a service or function as the ninth argument.
  STATUS_INVALID_PARAMETER_10 = HRESULT($C00000F8);
  // An invalid parameter was passed to a service or function as the tenth argument.
  STATUS_INVALID_PARAMETER_11 = HRESULT($C00000F9);
  // An invalid parameter was passed to a service or function as the eleventh argument.
  STATUS_INVALID_PARAMETER_12 = HRESULT($C00000FA);
  // An invalid parameter was passed to a service or function as the twelfth argument.
  STATUS_REDIRECTOR_NOT_STARTED = HRESULT($C00000FB);
  // An attempt was made to access a network file, but the network software was not yet started.
  STATUS_REDIRECTOR_STARTED = HRESULT($C00000FC);
  // An attempt was made to start the redirector, but the redirector has already been started.
  STATUS_STACK_OVERFLOW = HRESULT($C00000FD);
  // A new guard page for the stack cannot be created.
  STATUS_NO_SUCH_PACKAGE = HRESULT($C00000FE);
  // A specified authentication package is unknown.
  STATUS_BAD_FUNCTION_TABLE = HRESULT($C00000FF);
  // A malformed function table was encountered during an unwind operation.
  STATUS_VARIABLE_NOT_FOUND = HRESULT($C0000100);
  // Indicates the specified environment variable name was not found in the specified environment block.
  STATUS_DIRECTORY_NOT_EMPTY = HRESULT($C0000101);
  // Indicates that the directory trying to be deleted is not empty.
  STATUS_FILE_CORRUPT_ERROR = HRESULT($C0000102);
  // {Corrupt File} The file or directory %hs is corrupt and unreadable. Run the Chkdsk utility.
  STATUS_NOT_A_DIRECTORY = HRESULT($C0000103);
  // A requested opened file is not a directory.
  STATUS_BAD_LOGON_SESSION_STATE = HRESULT($C0000104);
  // The logon session is not in a state that is consistent with the requested operation.
  STATUS_LOGON_SESSION_COLLISION = HRESULT($C0000105);
  // An internal LSA error has occurred. An authentication package has requested the creation of a logon session but the ID of an already existing logon session has been specified.
  STATUS_NAME_TOO_LONG = HRESULT($C0000106);
  // A specified name string is too long for its intended use.
  STATUS_FILES_OPEN = HRESULT($C0000107);
  // The user attempted to force close the files on a redirected drive, but there were opened files on the drive, and the user did not specify a sufficient level of force.
  STATUS_CONNECTION_IN_USE = HRESULT($C0000108);
  // The user attempted to force close the files on a redirected drive, but there were opened directories on the drive, and the user did not specify a sufficient level of force.
  STATUS_MESSAGE_NOT_FOUND = HRESULT($C0000109);
  // RtlFindMessage could not locate the requested message ID in the message table resource.
  STATUS_PROCESS_IS_TERMINATING = HRESULT($C000010A);
  // An attempt was made to duplicate an object handle into or out of an exiting process.
  STATUS_INVALID_LOGON_TYPE = HRESULT($C000010B);
  // Indicates an invalid value has been provided for the LogonType requested.
  STATUS_NO_GUID_TRANSLATION = HRESULT($C000010C);
  // Indicates that an attempt was made to assign protection to a file system file or directory and one of the SIDs in the security descriptor could not be translated into a GUID that could be stored by the file system. This causes the protection attempt to fail, which might cause a file creation attempt to fail.
  STATUS_CANNOT_IMPERSONATE = HRESULT($C000010D);
  // Indicates that an attempt has been made to impersonate via a named pipe that has not yet been read from.
  STATUS_IMAGE_ALREADY_LOADED = HRESULT($C000010E);
  // Indicates that the specified image is already loaded.
  STATUS_NO_LDT = HRESULT($C0000117);
  // Indicates that an attempt was made to change the size of the LDT for a process that has no LDT.
  STATUS_INVALID_LDT_SIZE = HRESULT($C0000118);
  // Indicates that an attempt was made to grow an LDT by setting its size, or that the size was not an even number of selectors.
  STATUS_INVALID_LDT_OFFSET = HRESULT($C0000119);
  // Indicates that the starting value for the LDT information was not an integral multiple of the selector size.
  STATUS_INVALID_LDT_DESCRIPTOR = HRESULT($C000011A);
  // Indicates that the user supplied an invalid descriptor when trying to set up LDT descriptors.
  STATUS_INVALID_IMAGE_NE_FORMAT = HRESULT($C000011B);
  // The specified image file did not have the correct format. It appears to be NE format.
  STATUS_RXACT_INVALID_STATE = HRESULT($C000011C);
  // Indicates that the transaction state of a registry subtree is incompatible with the requested operation. For example, a request has been made to start a new transaction with one already in progress, or a request has been made to apply a transaction when one is not currently in progress.
  STATUS_RXACT_COMMIT_FAILURE = HRESULT($C000011D);
  // Indicates an error has occurred during a registry transaction commit. The database has been left in an unknown, but probably inconsistent, state. The state of the registry transaction is left as COMMITTING.
  STATUS_MAPPED_FILE_SIZE_ZERO = HRESULT($C000011E);
  // An attempt was made to map a file of size zero with the maximum size specified as zero.
  STATUS_TOO_MANY_OPENED_FILES = HRESULT($C000011F);
  // Too many files are opened on a remote server. This error should only be returned by the Windows redirector on a remote drive.
  STATUS_CANCELLED     = HRESULT($C0000120); // The I/O request was canceled.
  STATUS_CANNOT_DELETE = HRESULT($C0000121);
  // An attempt has been made to remove a file or directory that cannot be deleted.
  STATUS_INVALID_COMPUTER_NAME = HRESULT($C0000122);
  // Indicates a name that was specified as a remote computer name is syntactically invalid.
  STATUS_FILE_DELETED = HRESULT($C0000123);
  // An I/O request other than close was performed on a file after it was deleted, which can only happen to a request that did not complete before the last handle was closed via NtClose.
  STATUS_SPECIAL_ACCOUNT = HRESULT($C0000124);
  // Indicates an operation that is incompatible with built-in accounts has been attempted on a built-in (special) SAM account. For example, built-in accounts cannot be deleted.
  STATUS_SPECIAL_GROUP = HRESULT($C0000125);
  // The operation requested cannot be performed on the specified group because it is a built-in special group.
  STATUS_SPECIAL_USER = HRESULT($C0000126);
  // The operation requested cannot be performed on the specified user because it is a built-in special user.
  STATUS_MEMBERS_PRIMARY_GROUP = HRESULT($C0000127);
  // Indicates a member cannot be removed from a group because the group is currently the member's primary group.
  STATUS_FILE_CLOSED = HRESULT($C0000128);
  // An I/O request other than close and several other special case operations was attempted using a file object that had already been closed.
  STATUS_TOO_MANY_THREADS = HRESULT($C0000129);
  // Indicates a process has too many threads to perform the requested action. For example, assignment of a primary token can be performed only when a process has zero or one threads.
  STATUS_THREAD_NOT_IN_PROCESS = HRESULT($C000012A);
  // An attempt was made to operate on a thread within a specific process, but the specified thread is not in the specified process.
  STATUS_TOKEN_ALREADY_IN_USE = HRESULT($C000012B);
  // An attempt was made to establish a token for use as a primary token but the token is already in use. A token can only be the primary token of one process at a time.
  STATUS_PAGEFILE_QUOTA_EXCEEDED = HRESULT($C000012C);
  // The page file quota was exceeded.
  STATUS_COMMITMENT_LIMIT = HRESULT($C000012D);
  // {Out of Virtual Memory} Your system is low on virtual memory. To ensure that Windows runs correctly, increase the size of your virtual memory paging file. For more information, see Help.
  STATUS_INVALID_IMAGE_LE_FORMAT = HRESULT($C000012E);
  // The specified image file did not have the correct format: it appears to be LE format.
  STATUS_INVALID_IMAGE_NOT_MZ = HRESULT($C000012F);
  // The specified image file did not have the correct format: it did not have an initial MZ.
  STATUS_INVALID_IMAGE_PROTECT = HRESULT($C0000130);
  // The specified image file did not have the correct format: it did not have a proper e_lfarlc in the MZ header.
  STATUS_INVALID_IMAGE_WIN_16 = HRESULT($C0000131);
  // The specified image file did not have the correct format: it appears to be a 16-bit Windows image.
  STATUS_LOGON_SERVER_CONFLICT = HRESULT($C0000132);
  // The Netlogon service cannot start because another Netlogon service running in the domain conflicts with the specified role.
  STATUS_TIME_DIFFERENCE_AT_DC = HRESULT($C0000133);
  // The time at the primary domain controller is different from the time at the backup domain controller or member server by too large an amount.
  STATUS_SYNCHRONIZATION_REQUIRED = HRESULT($C0000134);
  // On applicable Windows Server releases, the SAM database is significantly out of synchronization with the copy on the domain controller. A complete synchronization is required.
  STATUS_DLL_NOT_FOUND = HRESULT($C0000135);
  // {Unable To Locate Component} This application has failed to start because %hs was not found. Reinstalling the application might fix this problem.
  STATUS_OPEN_FAILED = HRESULT($C0000136);
  // The NtCreateFile API failed. This error should never be returned to an application); it is a place holder for the Windows LAN Manager Redirector to use in its internal error-mapping routines.
  STATUS_IO_PRIVILEGE_FAILED = HRESULT($C0000137);
  // {Privilege Failed} The I/O permissions for the process could not be changed.
  STATUS_ORDINAL_NOT_FOUND = HRESULT($C0000138);
  // {Ordinal Not Found} The ordinal %ld could not be located in the dynamic link library %hs.
  STATUS_ENTRYPOINT_NOT_FOUND = HRESULT($C0000139);
  // {Entry Point Not Found} The procedure entry point %hs could not be located in the dynamic link library %hs.
  STATUS_CONTROL_C_EXIT = HRESULT($C000013A);
  // {Application Exit by CTRL+C} The application terminated as a result of a CTRL+C.
  STATUS_LOCAL_DISCONNECT = HRESULT($C000013B);
  // {Virtual Circuit Closed} The network transport on your computer has closed a network connection. There might or might not be I/O requests outstanding.
  STATUS_REMOTE_DISCONNECT = HRESULT($C000013C);
  // {Virtual Circuit Closed} The network transport on a remote computer has closed a network connection. There might or might not be I/O requests outstanding.
  STATUS_REMOTE_RESOURCES = HRESULT($C000013D);
  // {Insufficient Resources on Remote Computer} The remote computer has insufficient resources to complete the network request. For example, the remote computer might not have enough available memory to carry out the request at this time.
  STATUS_LINK_FAILED = HRESULT($C000013E);
  // {Virtual Circuit Closed} An existing connection (virtual circuit) has been broken at the remote computer. There is probably something wrong with the network software protocol or the network hardware on the remote computer.
  STATUS_LINK_TIMEOUT = HRESULT($C000013F);
  // {Virtual Circuit Closed} The network transport on your computer has closed a network connection because it had to wait too long for a response from the remote computer.
  STATUS_INVALID_CONNECTION = HRESULT($C0000140);
  // The connection handle that was given to the transport was invalid.
  STATUS_INVALID_ADDRESS = HRESULT($C0000141);
  // The address handle that was given to the transport was invalid.
  STATUS_DLL_INIT_FAILED = HRESULT($C0000142);
  // {DLL Initialization Failed} Initialization of the dynamic link library %hs failed. The process is terminating abnormally.
  STATUS_MISSING_SYSTEMFILE = HRESULT($C0000143);
  // {Missing System File} The required system file %hs is bad or missing.
  STATUS_UNHANDLED_EXCEPTION = HRESULT($C0000144);
  // {Application Error} The exception %s ($%08lx) occurred in the application at location $%08lx.
  STATUS_APP_INIT_FAILURE = HRESULT($C0000145);
  // {Application Error} The application failed to initialize properly ($%lx). Click OK to terminate the application.
  STATUS_PAGEFILE_CREATE_FAILED = HRESULT($C0000146);
  // {Unable to Create Paging File} The creation of the paging file %hs failed (%lx). The requested size was %ld.
  STATUS_NO_PAGEFILE = HRESULT($C0000147);
  // {No Paging File Specified} No paging file was specified in the system configuration.
  STATUS_INVALID_LEVEL = HRESULT($C0000148);
  // {Incorrect System Call Level} An invalid level was passed into the specified system call.
  STATUS_WRONG_PASSWORD_CORE = HRESULT($C0000149);
  // {Incorrect Password to LAN Manager Server} You specified an incorrect password to a LAN Manager 2.x or MS-NET server.
  STATUS_ILLEGAL_FLOAT_CONTEXT = HRESULT($C000014A);
  // {EXCEPTION} A real-mode application issued a floating-point instruction and floating-point hardware is not present.
  STATUS_PIPE_BROKEN = HRESULT($C000014B);
  // The pipe operation has failed because the other end of the pipe has been closed.
  STATUS_REGISTRY_CORRUPT = HRESULT($C000014C);
  // {The Registry Is Corrupt} The structure of one of the files that contains registry data is corrupt); the image of the file in memory is corrupt); or the file could not be recovered because the alternate copy or log was absent or corrupt.
  STATUS_REGISTRY_IO_FAILED = HRESULT($C000014D);
  // An I/O operation initiated by the Registry failed and cannot be recovered. The registry could not read in, write out, or flush one of the files that contain the system's image of the registry.
  STATUS_NO_EVENT_PAIR = HRESULT($C000014E);
  // An event pair synchronization operation was performed using the thread-specific client/server event pair object, but no event pair object was associated with the thread.
  STATUS_UNRECOGNIZED_VOLUME = HRESULT($C000014F);
  // The volume does not contain a recognized file system. Be sure that all required file system drivers are loaded and that the volume is not corrupt.
  STATUS_SERIAL_NO_DEVICE_INITED = HRESULT($C0000150);
  // No serial device was successfully initialized. The serial driver will unload.
  STATUS_NO_SUCH_ALIAS = HRESULT($C0000151); // The specified local group does not exist.
  STATUS_MEMBER_NOT_IN_ALIAS = HRESULT($C0000152);
  // The specified account name is not a member of the group.
  STATUS_MEMBER_IN_ALIAS = HRESULT($C0000153);
  // The specified account name is already a member of the group.
  STATUS_ALIAS_EXISTS = HRESULT($C0000154); // The specified local group already exists.
  STATUS_LOGON_NOT_GRANTED = HRESULT($C0000155);
  // A requested type of logon (for example, interactive, network, and service) is not granted by the local security policy of the target system. Ask the system administrator to grant the necessary form of logon.
  STATUS_TOO_MANY_SECRETS = HRESULT($C0000156);
  // The maximum number of secrets that can be stored in a single system was exceeded. The length and number of secrets is limited to satisfy U.S. State Department export restrictions.
  STATUS_SECRET_TOO_LONG = HRESULT($C0000157);
  // The length of a secret exceeds the maximum allowable length. The length and number of secrets is limited to satisfy U.S. State Department export restrictions.
  STATUS_INTERNAL_DB_ERROR = HRESULT($C0000158);
  // The local security authority (LSA) database contains an internal inconsistency.
  STATUS_FULLSCREEN_MODE = HRESULT($C0000159);
  // The requested operation cannot be performed in full-screen mode.
  STATUS_TOO_MANY_CONTEXT_IDS = HRESULT($C000015A);
  // During a logon attempt, the user's security context accumulated too many security IDs. This is a very unusual situation. Remove the user from some global or local groups to reduce the number of security IDs to incorporate into the security context.
  STATUS_LOGON_TYPE_NOT_GRANTED = HRESULT($C000015B);
  // A user has requested a type of logon (for example, interactive or network) that has not been granted. An administrator has control over who can logon interactively and through the network.
  STATUS_NOT_REGISTRY_FILE = HRESULT($C000015C);
  // The system has attempted to load or restore a file into the registry, and the specified file is not in the format of a registry file.
  STATUS_NT_CROSS_ENCRYPTION_REQUIRED = HRESULT($C000015D);
  // An attempt was made to change a user password in the security account manager without providing the necessary Windows cross-encrypted password.
  STATUS_DOMAIN_CTRLR_CONFIG_ERROR = HRESULT($C000015E);
  // A domain server has an incorrect configuration.
  STATUS_FT_MISSING_MEMBER = HRESULT($C000015F);
  // An attempt was made to explicitly access the secondary copy of information via a device control to the fault tolerance driver and the secondary copy is not present in the system.
  STATUS_ILL_FORMED_SERVICE_ENTRY = HRESULT($C0000160);
  // A configuration registry node that represents a driver service entry was ill-formed and did not contain the required value entries.
  STATUS_ILLEGAL_CHARACTER = HRESULT($C0000161);
  // An illegal character was encountered. For a multibyte character set, this includes a lead byte without a succeeding trail byte. For the Unicode character set this includes the characters $FFFF and $FFFE.
  STATUS_UNMAPPABLE_CHARACTER = HRESULT($C0000162);
  // No mapping for the Unicode character exists in the target multibyte code page.
  STATUS_UNDEFINED_CHARACTER = HRESULT($C0000163);
  // The Unicode character is not defined in the Unicode character set that is installed on the system.
  STATUS_FLOPPY_VOLUME = HRESULT($C0000164);
  // The paging file cannot be created on a floppy disk.
  STATUS_FLOPPY_ID_MARK_NOT_FOUND = HRESULT($C0000165);
  // {Floppy Disk Error} While accessing a floppy disk, an ID address mark was not found.
  STATUS_FLOPPY_WRONG_CYLINDER = HRESULT($C0000166);
  // {Floppy Disk Error} While accessing a floppy disk, the track address from the sector ID field was found to be different from the track address that is maintained by the controller.
  STATUS_FLOPPY_UNKNOWN_ERROR = HRESULT($C0000167);
  // {Floppy Disk Error} The floppy disk controller reported an error that is not recognized by the floppy disk driver.
  STATUS_FLOPPY_BAD_REGISTERS = HRESULT($C0000168);
  // {Floppy Disk Error} While accessing a floppy-disk, the controller returned inconsistent results via its registers.
  STATUS_DISK_RECALIBRATE_FAILED = HRESULT($C0000169);
  // {Hard Disk Error} While accessing the hard disk, a recalibrate operation failed, even after retries.
  STATUS_DISK_OPERATION_FAILED = HRESULT($C000016A);
  // {Hard Disk Error} While accessing the hard disk, a disk operation failed even after retries.
  STATUS_DISK_RESET_FAILED = HRESULT($C000016B);
  // {Hard Disk Error} While accessing the hard disk, a disk controller reset was needed, but even that failed.
  STATUS_SHARED_IRQ_BUSY = HRESULT($C000016C);
  // An attempt was made to open a device that was sharing an interrupt request (IRQ) with other devices. At least one other device that uses that IRQ was already opened. Two concurrent opens of devices that share an IRQ and only work via interrupts is not supported for the particular bus type that the devices use.
  STATUS_FT_ORPHANING = HRESULT($C000016D);
  // {FT Orphaning} A disk that is part of a fault-tolerant volume can no longer be accessed.
  STATUS_BIOS_FAILED_TO_CONNECT_INTERRUPT = HRESULT($C000016E);
  // The basic input/output system (BIOS) failed to connect a system interrupt to the device or bus for which the device is connected.
  STATUS_PARTITION_FAILURE = HRESULT($C0000172); // The tape could not be partitioned.
  STATUS_INVALID_BLOCK_LENGTH = HRESULT($C0000173);
  // When accessing a new tape of a multi-volume partition, the current blocksize is incorrect.
  STATUS_DEVICE_NOT_PARTITIONED = HRESULT($C0000174);
  // The tape partition information could not be found when loading a tape.
  STATUS_UNABLE_TO_LOCK_MEDIA = HRESULT($C0000175);
  // An attempt to lock the eject media mechanism failed.
  STATUS_UNABLE_TO_UNLOAD_MEDIA = HRESULT($C0000176);
  // An attempt to unload media failed.
  STATUS_EOM_OVERFLOW = HRESULT($C0000177); // The physical end of tape was detected.
  STATUS_NO_MEDIA     = HRESULT($C0000178);
  // {No Media} There is no media in the drive. Insert media into drive %hs.
  STATUS_NO_SUCH_MEMBER = HRESULT($C000017A);
  // A member could not be added to or removed from the local group because the member does not exist.
  STATUS_INVALID_MEMBER = HRESULT($C000017B);
  // A new member could not be added to a local group because the member has the wrong account type.
  STATUS_KEY_DELETED = HRESULT($C000017C);
  // An illegal operation was attempted on a registry key that has been marked for deletion.
  STATUS_NO_LOG_SPACE = HRESULT($C000017D);
  // The system could not allocate the required space in a registry log.
  STATUS_TOO_MANY_SIDS = HRESULT($C000017E); // Too many SIDs have been specified.
  STATUS_LM_CROSS_ENCRYPTION_REQUIRED = HRESULT($C000017F);
  // An attempt was made to change a user password in the security account manager without providing the necessary LM cross-encrypted password.
  STATUS_KEY_HAS_CHILDREN = HRESULT($C0000180);
  // An attempt was made to create a symbolic link in a registry key that already has subkeys or values.
  STATUS_CHILD_MUST_BE_VOLATILE = HRESULT($C0000181);
  // An attempt was made to create a stable subkey under a volatile parent key.
  STATUS_DEVICE_CONFIGURATION_ERROR = HRESULT($C0000182);
  // The I/O device is configured incorrectly or the configuration parameters to the driver are incorrect.
  STATUS_DRIVER_INTERNAL_ERROR = HRESULT($C0000183);
  // An error was detected between two drivers or within an I/O driver.
  STATUS_INVALID_DEVICE_STATE = HRESULT($C0000184);
  // The device is not in a valid state to perform this request.
  STATUS_IO_DEVICE_ERROR = HRESULT($C0000185); // The I/O device reported an I/O error.
  STATUS_DEVICE_PROTOCOL_ERROR = HRESULT($C0000186);
  // A protocol error was detected between the driver and the device.
  STATUS_BACKUP_CONTROLLER = HRESULT($C0000187);
  // This operation is only allowed for the primary domain controller of the domain.
  STATUS_LOG_FILE_FULL = HRESULT($C0000188);
  // The log file space is insufficient to support this operation.
  STATUS_TOO_LATE = HRESULT($C0000189);
  // A write operation was attempted to a volume after it was dismounted.
  STATUS_NO_TRUST_LSA_SECRET = HRESULT($C000018A);
  // The workstation does not have a trust secret for the primary domain in the local LSA database.
  STATUS_NO_TRUST_SAM_ACCOUNT = HRESULT($C000018B);
  // On applicable Windows Server releases, the SAM database does not have a computer account for this workstation trust relationship.
  STATUS_TRUSTED_DOMAIN_FAILURE = HRESULT($C000018C);
  // The logon request failed because the trust relationship between the primary domain and the trusted domain failed.
  STATUS_TRUSTED_RELATIONSHIP_FAILURE = HRESULT($C000018D);
  // The logon request failed because the trust relationship between this workstation and the primary domain failed.
  STATUS_EVENTLOG_FILE_CORRUPT = HRESULT($C000018E); // The Eventlog log file is corrupt.
  STATUS_EVENTLOG_CANT_START = HRESULT($C000018F);
  // No Eventlog log file could be opened. The Eventlog service did not start.
  STATUS_TRUST_FAILURE = HRESULT($C0000190);
  // The network logon failed. This might be because the validation authority cannot be reached.
  STATUS_MUTANT_LIMIT_EXCEEDED = HRESULT($C0000191);
  // An attempt was made to acquire a mutant such that its maximum count would have been exceeded.
  STATUS_NETLOGON_NOT_STARTED = HRESULT($C0000192);
  // An attempt was made to logon, but the NetLogon service was not started.
  STATUS_ACCOUNT_EXPIRED   = HRESULT($C0000193); // The user account has expired.
  STATUS_POSSIBLE_DEADLOCK = HRESULT($C0000194);
  // {EXCEPTION} Possible deadlock condition.
  STATUS_NETWORK_CREDENTIAL_CONFLICT = HRESULT($C0000195);
  // Multiple connections to a server or shared resource by the same user, using more than one user name, are not allowed. Disconnect all previous connections to the server or shared resource and try again.
  STATUS_REMOTE_SESSION_LIMIT = HRESULT($C0000196);
  // An attempt was made to establish a session to a network server, but there are already too many sessions established to that server.
  STATUS_EVENTLOG_FILE_CHANGED = HRESULT($C0000197);
  // The log file has changed between reads.
  STATUS_NOLOGON_INTERDOMAIN_TRUST_ACCOUNT = HRESULT($C0000198);
  // The account used is an interdomain trust account. Use your global user account or local user account to access this server.
  STATUS_NOLOGON_WORKSTATION_TRUST_ACCOUNT = HRESULT($C0000199);
  // The account used is a computer account. Use your global user account or local user account to access this server.
  STATUS_NOLOGON_SERVER_TRUST_ACCOUNT = HRESULT($C000019A);
  // The account used is a server trust account. Use your global user account or local user account to access this server.
  STATUS_DOMAIN_TRUST_INCONSISTENT = HRESULT($C000019B);
  // The name or SID of the specified domain is inconsistent with the trust information for that domain.
  STATUS_FS_DRIVER_REQUIRED = HRESULT($C000019C);
  // A volume has been accessed for which a file system driver is required that has not yet been loaded.
  STATUS_IMAGE_ALREADY_LOADED_AS_DLL = HRESULT($C000019D);
  // Indicates that the specified image is already loaded as a DLL.
  STATUS_INCOMPATIBLE_WITH_GLOBAL_SHORT_NAME_REGISTRY_SETTING = HRESULT($C000019E);
  // Short name settings cannot be changed on this volume due to the global registry setting.
  STATUS_SHORT_NAMES_NOT_ENABLED_ON_VOLUME = HRESULT($C000019F);
  // Short names are not enabled on this volume.
  STATUS_SECURITY_STREAM_IS_INCONSISTENT = HRESULT($C00001A0);
  // The security stream for the given volume is in an inconsistent state. Please run CHKDSK on the volume.
  STATUS_INVALID_LOCK_RANGE = HRESULT($C00001A1);
  // A requested file lock operation cannot be processed due to an invalid byte range.
  STATUS_INVALID_ACE_CONDITION = HRESULT($C00001A2);
  // The specified access control entry (ACE) contains an invalid condition.
  STATUS_IMAGE_SUBSYSTEM_NOT_PRESENT = HRESULT($C00001A3);
  // The subsystem needed to support the image type is not present.
  STATUS_NOTIFICATION_GUID_ALREADY_DEFINED = HRESULT($C00001A4);
  // The specified file already has a notification GUID associated with it.
  STATUS_NETWORK_OPEN_RESTRICTION = HRESULT($C0000201);
  // A remote open failed because the network open restrictions were not satisfied.
  STATUS_NO_USER_SESSION_KEY = HRESULT($C0000202);
  // There is no user session key for the specified logon session.
  STATUS_USER_SESSION_DELETED = HRESULT($C0000203);
  // The remote user session has been deleted.
  STATUS_RESOURCE_LANG_NOT_FOUND = HRESULT($C0000204);
  // Indicates the specified resource language ID cannot be found in the image file.
  STATUS_INSUFF_SERVER_RESOURCES = HRESULT($C0000205);
  // Insufficient server resources exist to complete the request.
  STATUS_INVALID_BUFFER_SIZE = HRESULT($C0000206);
  // The size of the buffer is invalid for the specified operation.
  STATUS_INVALID_ADDRESS_COMPONENT = HRESULT($C0000207);
  // The transport rejected the specified network address as invalid.
  STATUS_INVALID_ADDRESS_WILDCARD = HRESULT($C0000208);
  // The transport rejected the specified network address due to invalid use of a wildcard.
  STATUS_TOO_MANY_ADDRESSES = HRESULT($C0000209);
  // The transport address could not be opened because all the available addresses are in use.
  STATUS_ADDRESS_ALREADY_EXISTS = HRESULT($C000020A);
  // The transport address could not be opened because it already exists.
  STATUS_ADDRESS_CLOSED = HRESULT($C000020B); // The transport address is now closed.
  STATUS_CONNECTION_DISCONNECTED = HRESULT($C000020C);
  // The transport connection is now disconnected.
  STATUS_CONNECTION_RESET = HRESULT($C000020D);
  // The transport connection has been reset.
  STATUS_TOO_MANY_NODES = HRESULT($C000020E);
  // The transport cannot dynamically acquire any more nodes.
  STATUS_TRANSACTION_ABORTED = HRESULT($C000020F);
  // The transport aborted a pending transaction.
  STATUS_TRANSACTION_TIMED_OUT = HRESULT($C0000210);
  // The transport timed out a request that is waiting for a response.
  STATUS_TRANSACTION_NO_RELEASE = HRESULT($C0000211);
  // The transport did not receive a release for a pending response.
  STATUS_TRANSACTION_NO_MATCH = HRESULT($C0000212);
  // The transport did not find a transaction that matches the specific token.
  STATUS_TRANSACTION_RESPONDED = HRESULT($C0000213);
  // The transport had previously responded to a transaction request.
  STATUS_TRANSACTION_INVALID_ID = HRESULT($C0000214);
  // The transport does not recognize the specified transaction request ID.
  STATUS_TRANSACTION_INVALID_TYPE = HRESULT($C0000215);
  // The transport does not recognize the specified transaction request type.
  STATUS_NOT_SERVER_SESSION = HRESULT($C0000216);
  // The transport can only process the specified request on the server side of a session.
  STATUS_NOT_CLIENT_SESSION = HRESULT($C0000217);
  // The transport can only process the specified request on the client side of a session.
  STATUS_CANNOT_LOAD_REGISTRY_FILE = HRESULT($C0000218);
  // {Registry File Failure} The registry cannot load the hive (file): %hs or its log or alternate. It is corrupt, absent, or not writable.
  STATUS_DEBUG_ATTACH_FAILED = HRESULT($C0000219);
  // {Unexpected Failure in DebugActiveProcess} An unexpected failure occurred while processing a DebugActiveProcess API request. Choosing OK will terminate the process, and choosing Cancel will ignore the error.
  STATUS_SYSTEM_PROCESS_TERMINATED = HRESULT($C000021A);
  // {Fatal System Error} The %hs system process terminated unexpectedly with a status of $%08x ($%08x $%08x). The system has been shut down.
  STATUS_DATA_NOT_ACCEPTED = HRESULT($C000021B);
  // {Data Not Accepted} The TDI client could not handle the data received during an indication.
  STATUS_NO_BROWSER_SERVERS_FOUND = HRESULT($C000021C);
  // {Unable to Retrieve Browser Server List} The list of servers for this workgroup is not currently available.
  STATUS_VDM_HARD_ERROR        = HRESULT($C000021D); // NTVDM encountered a hard error.
  STATUS_DRIVER_CANCEL_TIMEOUT = HRESULT($C000021E);
  // {Cancel Timeout} The driver %hs failed to complete a canceled I/O request in the allotted time.
  STATUS_REPLY_MESSAGE_MISMATCH = HRESULT($C000021F);
  // {Reply Message Mismatch} An attempt was made to reply to an LPC message, but the thread specified by the client ID in the message was not waiting on that message.
  STATUS_MAPPED_ALIGNMENT = HRESULT($C0000220);
  // {Mapped View Alignment Incorrect} An attempt was made to map a view of a file, but either the specified base address or the offset into the file were not aligned on the proper allocation granularity.
  STATUS_IMAGE_CHECKSUM_MISMATCH = HRESULT($C0000221);
  // {Bad Image Checksum} The image %hs is possibly corrupt. The header checksum does not match the computed checksum.
  STATUS_LOST_WRITEBEHIND_DATA = HRESULT($C0000222);
  // {Delayed Write Failed} Windows was unable to save all the data for the file %hs. The data has been lost. This error might be caused by a failure of your computer hardware or network connection. Try to save this file elsewhere.
  STATUS_CLIENT_SERVER_PARAMETERS_INVALID = HRESULT($C0000223);
  // The parameters passed to the server in the client/server shared memory window were invalid. Too much data might have been put in the shared memory window.
  STATUS_PASSWORD_MUST_CHANGE = HRESULT($C0000224);
  // The user password must be changed before logging on the first time.
  STATUS_NOT_FOUND           = HRESULT($C0000225); // The object was not found.
  STATUS_NOT_TINY_STREAM     = HRESULT($C0000226); // The stream is not a tiny stream.
  STATUS_RECOVERY_FAILURE    = HRESULT($C0000227); // A transaction recovery failed.
  STATUS_STACK_OVERFLOW_READ = HRESULT($C0000228);
  // The request must be handled by the stack overflow code.
  STATUS_FAIL_CHECK         = HRESULT($C0000229); // A consistency check failed.
  STATUS_DUPLICATE_OBJECTID = HRESULT($C000022A);
  // The attempt to insert the ID in the index failed because the ID is already in the index.
  STATUS_OBJECTID_EXISTS = HRESULT($C000022B);
  // The attempt to set the object ID failed because the object already has an ID.
  STATUS_CONVERT_TO_LARGE = HRESULT($C000022C);
  // Internal OFS status codes indicating how an allocation operation is handled. Either it is retried after the containing oNode is moved or the extent stream is converted to a large stream.
  STATUS_RETRY              = HRESULT($C000022D); // The request needs to be retried.
  STATUS_FOUND_OUT_OF_SCOPE = HRESULT($C000022E);
  // The attempt to find the object found an object on the volume that matches by ID); however, it is out of the scope of the handle that is used for the operation.
  STATUS_ALLOCATE_BUCKET = HRESULT($C000022F);
  // The bucket array must be grown. Retry the transaction after doing so.
  STATUS_PROPSET_NOT_FOUND = HRESULT($C0000230);
  // The specified property set does not exist on the object.
  STATUS_MARSHALL_OVERFLOW = HRESULT($C0000231);
  // The user/kernel marshaling buffer has overflowed.
  STATUS_INVALID_VARIANT = HRESULT($C0000232);
  // The supplied variant structure contains invalid data.
  STATUS_DOMAIN_CONTROLLER_NOT_FOUND = HRESULT($C0000233);
  // A domain controller for this domain was not found.
  STATUS_ACCOUNT_LOCKED_OUT = HRESULT($C0000234);
  // The user account has been automatically locked because too many invalid logon attempts or password change attempts have been requested.
  STATUS_HANDLE_NOT_CLOSABLE = HRESULT($C0000235);
  // NtClose was called on a handle that was protected from close via NtSetInformationObject.
  STATUS_CONNECTION_REFUSED = HRESULT($C0000236);
  // The transport-connection attempt was refused by the remote system.
  STATUS_GRACEFUL_DISCONNECT = HRESULT($C0000237);
  // The transport connection was gracefully closed.
  STATUS_ADDRESS_ALREADY_ASSOCIATED = HRESULT($C0000238);
  // The transport endpoint already has an address associated with it.
  STATUS_ADDRESS_NOT_ASSOCIATED = HRESULT($C0000239);
  // An address has not yet been associated with the transport endpoint.
  STATUS_CONNECTION_INVALID = HRESULT($C000023A);
  // An operation was attempted on a nonexistent transport connection.
  STATUS_CONNECTION_ACTIVE = HRESULT($C000023B);
  // An invalid operation was attempted on an active transport connection.
  STATUS_NETWORK_UNREACHABLE = HRESULT($C000023C);
  // The remote network is not reachable by the transport.
  STATUS_HOST_UNREACHABLE = HRESULT($C000023D);
  // The remote system is not reachable by the transport.
  STATUS_PROTOCOL_UNREACHABLE = HRESULT($C000023E);
  // The remote system does not support the transport protocol.
  STATUS_PORT_UNREACHABLE = HRESULT($C000023F);
  // No service is operating at the destination port of the transport on the remote system.
  STATUS_REQUEST_ABORTED    = HRESULT($C0000240); // The request was aborted.
  STATUS_CONNECTION_ABORTED = HRESULT($C0000241);
  // The transport connection was aborted by the local system.
  STATUS_BAD_COMPRESSION_BUFFER = HRESULT($C0000242);
  // The specified buffer contains ill-formed data.
  STATUS_USER_MAPPED_FILE = HRESULT($C0000243);
  // The requested operation cannot be performed on a file with a user mapped section open.
  STATUS_AUDIT_FAILED = HRESULT($C0000244);
  // {Audit Failed} An attempt to generate a security audit failed.
  STATUS_TIMER_RESOLUTION_NOT_SET = HRESULT($C0000245);
  // The timer resolution was not previously set by the current process.
  STATUS_CONNECTION_COUNT_LIMIT = HRESULT($C0000246);
  // A connection to the server could not be made because the limit on the number of concurrent connections for this account has been reached.
  STATUS_LOGIN_TIME_RESTRICTION = HRESULT($C0000247);
  // Attempting to log on during an unauthorized time of day for this account.
  STATUS_LOGIN_WKSTA_RESTRICTION = HRESULT($C0000248);
  // The account is not authorized to log on from this station.
  STATUS_IMAGE_MP_UP_MISMATCH = HRESULT($C0000249);
  // {UP/MP Image Mismatch} The image %hs has been modified for use on a uniprocessor system, but you are running it on a multiprocessor machine. Reinstall the image file.
  STATUS_INSUFFICIENT_LOGON_INFO = HRESULT($C0000250);
  // There is insufficient account information to log you on.
  STATUS_BAD_DLL_ENTRYPOINT = HRESULT($C0000251);
  // {Invalid DLL Entrypoint} The dynamic link library %hs is not written correctly. The stack pointer has been left in an inconsistent state. The entry point should be declared as WINAPI or STDCALL. Select YES to fail the DLL load. Select NO to continue execution. Selecting NO might cause the application to operate incorrectly.
  STATUS_BAD_SERVICE_ENTRYPOINT = HRESULT($C0000252);
  // {Invalid Service Callback Entrypoint} The %hs service is not written correctly. The stack pointer has been left in an inconsistent state. The callback entry point should be declared as WINAPI or STDCALL. Selecting OK will cause the service to continue operation. However, the service process might operate incorrectly.
  STATUS_LPC_REPLY_LOST = HRESULT($C0000253);
  // The server received the messages but did not send a reply.
  STATUS_IP_ADDRESS_CONFLICT1 = HRESULT($C0000254);
  // There is an IP address conflict with another system on the network.
  STATUS_IP_ADDRESS_CONFLICT2 = HRESULT($C0000255);
  // There is an IP address conflict with another system on the network.
  STATUS_REGISTRY_QUOTA_LIMIT = HRESULT($C0000256);
  // {Low On Registry Space} The system has reached the maximum size that is allowed for the system part of the registry. Additional storage requests will be ignored.
  STATUS_PATH_NOT_COVERED = HRESULT($C0000257);
  // The contacted server does not support the indicated part of the DFS namespace.
  STATUS_NO_CALLBACK_ACTIVE = HRESULT($C0000258);
  // A callback return system service cannot be executed when no callback is active.
  STATUS_LICENSE_QUOTA_EXCEEDED = HRESULT($C0000259);
  // The service being accessed is licensed for a particular number of connections. No more connections can be made to the service at this time because the service has already accepted the maximum number of connections.
  STATUS_PWD_TOO_SHORT = HRESULT($C000025A);
  // The password provided is too short to meet the policy of your user account. Choose a longer password.
  STATUS_PWD_TOO_RECENT = HRESULT($C000025B);
  // The policy of your user account does not allow you to change passwords too frequently. This is done to prevent users from changing back to a familiar, but potentially discovered, password. If you feel your password has been compromised, contact your administrator immediately to have a new one assigned.
  STATUS_PWD_HISTORY_CONFLICT = HRESULT($C000025C);
  // You have attempted to change your password to one that you have used in the past. The policy of your user account does not allow this. Select a password that you have not previously used.
  STATUS_PLUGPLAY_NO_DEVICE = HRESULT($C000025E);
  // You have attempted to load a legacy device driver while its device instance had been disabled.
  STATUS_UNSUPPORTED_COMPRESSION = HRESULT($C000025F);
  // The specified compression format is unsupported.
  STATUS_INVALID_HW_PROFILE = HRESULT($C0000260);
  // The specified hardware profile configuration is invalid.
  STATUS_INVALID_PLUGPLAY_DEVICE_PATH = HRESULT($C0000261);
  // The specified Plug and Play registry device path is invalid.
  STATUS_DRIVER_ORDINAL_NOT_FOUND = HRESULT($C0000262);
  // {Driver Entry Point Not Found} The %hs device driver could not locate the ordinal %ld in driver %hs.
  STATUS_DRIVER_ENTRYPOINT_NOT_FOUND = HRESULT($C0000263);
  // {Driver Entry Point Not Found} The %hs device driver could not locate the entry point %hs in driver %hs.
  STATUS_RESOURCE_NOT_OWNED = HRESULT($C0000264);
  // {Application Error} The application attempted to release a resource it did not own. Click OK to terminate the application.
  STATUS_TOO_MANY_LINKS = HRESULT($C0000265);
  // An attempt was made to create more links on a file than the file system supports.
  STATUS_QUOTA_LIST_INCONSISTENT = HRESULT($C0000266);
  // The specified quota list is internally inconsistent with its descriptor.
  STATUS_FILE_IS_OFFLINE = HRESULT($C0000267);
  // The specified file has been relocated to offline storage.
  STATUS_EVALUATION_EXPIRATION = HRESULT($C0000268);
  // {Windows Evaluation Notification} The evaluation period for this installation of Windows has expired. This system will shutdown in 1 hour. To restore access to this installation of Windows, upgrade this installation by using a licensed distribution of this product.
  STATUS_ILLEGAL_DLL_RELOCATION = HRESULT($C0000269);
  // {Illegal System DLL Relocation} The system DLL %hs was relocated in memory. The application will not run properly. The relocation occurred because the DLL %hs occupied an address range that is reserved for Windows system DLLs. The vendor supplying the DLL should be contacted for a new DLL.
  STATUS_LICENSE_VIOLATION = HRESULT($C000026A);
  // {License Violation} The system has detected tampering with your registered product type. This is a violation of your software license. Tampering with the product type is not permitted.
  STATUS_DLL_INIT_FAILED_LOGOFF = HRESULT($C000026B);
  // {DLL Initialization Failed} The application failed to initialize because the window station is shutting down.
  STATUS_DRIVER_UNABLE_TO_LOAD = HRESULT($C000026C);
  // {Unable to Load Device Driver} %hs device driver could not be loaded. Error Status was $%x.
  STATUS_DFS_UNAVAILABLE = HRESULT($C000026D);
  // DFS is unavailable on the contacted server.
  STATUS_VOLUME_DISMOUNTED = HRESULT($C000026E);
  // An operation was attempted to a volume after it was dismounted.
  STATUS_WX86_INTERNAL_ERROR = HRESULT($C000026F);
  // An internal error occurred in the Win32 x86 emulation subsystem.
  STATUS_WX86_FLOAT_STACK_CHECK = HRESULT($C0000270);
  // Win32 x86 emulation subsystem floating-point stack check.
  STATUS_VALIDATE_CONTINUE = HRESULT($C0000271);
  // The validation process needs to continue on to the next step.
  STATUS_NO_MATCH = HRESULT($C0000272);
  // There was no match for the specified key in the index.
  STATUS_NO_MORE_MATCHES = HRESULT($C0000273);
  // There are no more matches for the current index enumeration.
  STATUS_NOT_A_REPARSE_POINT = HRESULT($C0000275);
  // The NTFS file or directory is not a reparse point.
  STATUS_IO_REPARSE_TAG_INVALID = HRESULT($C0000276);
  // The Windows I/O reparse tag passed for the NTFS reparse point is invalid.
  STATUS_IO_REPARSE_TAG_MISMATCH = HRESULT($C0000277);
  // The Windows I/O reparse tag does not match the one that is in the NTFS reparse point.
  STATUS_IO_REPARSE_DATA_INVALID = HRESULT($C0000278);
  // The user data passed for the NTFS reparse point is invalid.
  STATUS_IO_REPARSE_TAG_NOT_HANDLED = HRESULT($C0000279);
  // The layered file system driver for this I/O tag did not handle it when needed.
  STATUS_REPARSE_POINT_NOT_RESOLVED = HRESULT($C0000280);
  // The NTFS symbolic link could not be resolved even though the initial file name is valid.
  STATUS_DIRECTORY_IS_A_REPARSE_POINT = HRESULT($C0000281);
  // The NTFS directory is a reparse point.
  STATUS_RANGE_LIST_CONFLICT = HRESULT($C0000282);
  // The range could not be added to the range list because of a conflict.
  STATUS_SOURCE_ELEMENT_EMPTY = HRESULT($C0000283);
  // The specified medium changer source element contains no media.
  STATUS_DESTINATION_ELEMENT_FULL = HRESULT($C0000284);
  // The specified medium changer destination element already contains media.
  STATUS_ILLEGAL_ELEMENT_ADDRESS = HRESULT($C0000285);
  // The specified medium changer element does not exist.
  STATUS_MAGAZINE_NOT_PRESENT = HRESULT($C0000286);
  // The specified element is contained in a magazine that is no longer present.
  STATUS_REINITIALIZATION_NEEDED = HRESULT($C0000287);
  // The device requires re-initialization due to hardware errors.
  STATUS_ENCRYPTION_FAILED = HRESULT($C000028A); // The file encryption attempt failed.
  STATUS_DECRYPTION_FAILED = HRESULT($C000028B); // The file decryption attempt failed.
  STATUS_RANGE_NOT_FOUND   = HRESULT($C000028C);
  // The specified range could not be found in the range list.
  STATUS_NO_RECOVERY_POLICY = HRESULT($C000028D);
  // There is no encryption recovery policy configured for this system.
  STATUS_NO_EFS = HRESULT($C000028E);
  // The required encryption driver is not loaded for this system.
  STATUS_WRONG_EFS = HRESULT($C000028F);
  // The file was encrypted with a different encryption driver than is currently loaded.
  STATUS_NO_USER_KEYS = HRESULT($C0000290);
  // There are no EFS keys defined for the user.
  STATUS_FILE_NOT_ENCRYPTED = HRESULT($C0000291); // The specified file is not encrypted.
  STATUS_NOT_EXPORT_FORMAT = HRESULT($C0000292);
  // The specified file is not in the defined EFS export format.
  STATUS_FILE_ENCRYPTED = HRESULT($C0000293);
  // The specified file is encrypted and the user does not have the ability to decrypt it.
  STATUS_WMI_GUID_NOT_FOUND = HRESULT($C0000295);
  // The GUID passed was not recognized as valid by a WMI data provider.
  STATUS_WMI_INSTANCE_NOT_FOUND = HRESULT($C0000296);
  // The instance name passed was not recognized as valid by a WMI data provider.
  STATUS_WMI_ITEMID_NOT_FOUND = HRESULT($C0000297);
  // The data item ID passed was not recognized as valid by a WMI data provider.
  STATUS_WMI_TRY_AGAIN = HRESULT($C0000298);
  // The WMI request could not be completed and should be retried.
  STATUS_SHARED_POLICY = HRESULT($C0000299);
  // The policy object is shared and can only be modified at the root.
  STATUS_POLICY_OBJECT_NOT_FOUND = HRESULT($C000029A);
  // The policy object does not exist when it should.
  STATUS_POLICY_ONLY_IN_DS = HRESULT($C000029B);
  // The requested policy information only lives in the Ds.
  STATUS_VOLUME_NOT_UPGRADED = HRESULT($C000029C);
  // The volume must be upgraded to enable this feature.
  STATUS_REMOTE_STORAGE_NOT_ACTIVE = HRESULT($C000029D);
  // The remote storage service is not operational at this time.
  STATUS_REMOTE_STORAGE_MEDIA_ERROR = HRESULT($C000029E);
  // The remote storage service encountered a media error.
  STATUS_NO_TRACKING_SERVICE = HRESULT($C000029F);
  // The tracking (workstation) service is not running.
  STATUS_SERVER_SID_MISMATCH = HRESULT($C00002A0);
  // The server process is running under a SID that is different from the SID that is required by client.
  STATUS_DS_NO_ATTRIBUTE_OR_VALUE = HRESULT($C00002A1);
  // The specified directory service attribute or value does not exist.
  STATUS_DS_INVALID_ATTRIBUTE_SYNTAX = HRESULT($C00002A2);
  // The attribute syntax specified to the directory service is invalid.
  STATUS_DS_ATTRIBUTE_TYPE_UNDEFINED = HRESULT($C00002A3);
  // The attribute type specified to the directory service is not defined.
  STATUS_DS_ATTRIBUTE_OR_VALUE_EXISTS = HRESULT($C00002A4);
  // The specified directory service attribute or value already exists.
  STATUS_DS_BUSY        = HRESULT($C00002A5); // The directory service is busy.
  STATUS_DS_UNAVAILABLE = HRESULT($C00002A6); // The directory service is unavailable.
  STATUS_DS_NO_RIDS_ALLOCATED = HRESULT($C00002A7);
  // The directory service was unable to allocate a relative identifier.
  STATUS_DS_NO_MORE_RIDS = HRESULT($C00002A8);
  // The directory service has exhausted the pool of relative identifiers.
  STATUS_DS_INCORRECT_ROLE_OWNER = HRESULT($C00002A9);
  // The requested operation could not be performed because the directory service is not the master for that type of operation.
  STATUS_DS_RIDMGR_INIT_ERROR = HRESULT($C00002AA);
  // The directory service was unable to initialize the subsystem that allocates relative identifiers.
  STATUS_DS_OBJ_CLASS_VIOLATION = HRESULT($C00002AB);
  // The requested operation did not satisfy one or more constraints that are associated with the class of the object.
  STATUS_DS_CANT_ON_NON_LEAF = HRESULT($C00002AC);
  // The directory service can perform the requested operation only on a leaf object.
  STATUS_DS_CANT_ON_RDN = HRESULT($C00002AD);
  // The directory service cannot perform the requested operation on the Relatively Defined Name (RDN) attribute of an object.
  STATUS_DS_CANT_MOD_OBJ_CLASS = HRESULT($C00002AE);
  // The directory service detected an attempt to modify the object class of an object.
  STATUS_DS_CROSS_DOM_MOVE_FAILED = HRESULT($C00002AF);
  // An error occurred while performing a cross domain move operation.
  STATUS_DS_GC_NOT_AVAILABLE = HRESULT($C00002B0);
  // Unable to contact the global catalog server.
  STATUS_DIRECTORY_SERVICE_REQUIRED = HRESULT($C00002B1);
  // The requested operation requires a directory service, and none was available.
  STATUS_REPARSE_ATTRIBUTE_CONFLICT = HRESULT($C00002B2);
  // The reparse attribute cannot be set because it is incompatible with an existing attribute.
  STATUS_CANT_ENABLE_DENY_ONLY = HRESULT($C00002B3);
  // A group marked "use for deny only" cannot be enabled.
  STATUS_FLOAT_MULTIPLE_FAULTS = HRESULT($C00002B4);
  // {EXCEPTION} Multiple floating-point faults.
  STATUS_FLOAT_MULTIPLE_TRAPS = HRESULT($C00002B5);
  // {EXCEPTION} Multiple floating-point traps.
  STATUS_DEVICE_REMOVED = HRESULT($C00002B6); // The device has been removed.
  STATUS_JOURNAL_DELETE_IN_PROGRESS = HRESULT($C00002B7);
  // The volume change journal is being deleted.
  STATUS_JOURNAL_NOT_ACTIVE = HRESULT($C00002B8);
  // The volume change journal is not active.
  STATUS_NOINTERFACE = HRESULT($C00002B9); // The requested interface is not supported.
  STATUS_DS_ADMIN_LIMIT_EXCEEDED = HRESULT($C00002C1);
  // A directory service resource limit has been exceeded.
  STATUS_DRIVER_FAILED_SLEEP = HRESULT($C00002C2);
  // {System Standby Failed} The driver %hs does not support standby mode. Updating this driver allows the system to go to standby mode.
  STATUS_MUTUAL_AUTHENTICATION_FAILED = HRESULT($C00002C3);
  // Mutual Authentication failed. The server password is out of date at the domain controller.
  STATUS_CORRUPT_SYSTEM_FILE = HRESULT($C00002C4);
  // The system file %1 has become corrupt and has been replaced.
  STATUS_DATATYPE_MISALIGNMENT_ERROR = HRESULT($C00002C5);
  // {EXCEPTION} Alignment Error A data type misalignment error was detected in a load or store instruction.
  STATUS_WMI_READ_ONLY = HRESULT($C00002C6);
  // The WMI data item or data block is read-only.
  STATUS_WMI_SET_FAILURE = HRESULT($C00002C7);
  // The WMI data item or data block could not be changed.
  STATUS_COMMITMENT_MINIMUM = HRESULT($C00002C8);
  // {Virtual Memory Minimum Too Low} Your system is low on virtual memory. Windows is increasing the size of your virtual memory paging file. During this process, memory requests for some applications might be denied. For more information, see Help.
  STATUS_REG_NAT_CONSUMPTION = HRESULT($C00002C9);
  // {EXCEPTION} Register NaT consumption faults. A NaT value is consumed on a non-speculative instruction.
  STATUS_TRANSPORT_FULL = HRESULT($C00002CA);
  // The transport element of the medium changer contains media, which is causing the operation to fail.
  STATUS_DS_SAM_INIT_FAILURE = HRESULT($C00002CB);
  // Security Accounts Manager initialization failed because of the following error: %hs Error Status: $%x. Click OK to shut down this system and restart in Directory Services Restore Mode. Check the event log for more detailed information.
  STATUS_ONLY_IF_CONNECTED = HRESULT($C00002CC);
  // This operation is supported only when you are connected to the server.
  STATUS_DS_SENSITIVE_GROUP_VIOLATION = HRESULT($C00002CD);
  // Only an administrator can modify the membership list of an administrative group.
  STATUS_PNP_RESTART_ENUMERATION = HRESULT($C00002CE);
  // A device was removed so enumeration must be restarted.
  STATUS_JOURNAL_ENTRY_DELETED = HRESULT($C00002CF);
  // The journal entry has been deleted from the journal.
  STATUS_DS_CANT_MOD_PRIMARYGROUPID = HRESULT($C00002D0);
  // Cannot change the primary group ID of a domain controller account.
  STATUS_SYSTEM_IMAGE_BAD_SIGNATURE = HRESULT($C00002D1);
  // {Fatal System Error} The system image %s is not properly signed. The file has been replaced with the signed file. The system has been shut down.
  STATUS_PNP_REBOOT_REQUIRED = HRESULT($C00002D2);
  // The device will not start without a reboot.
  STATUS_POWER_STATE_INVALID = HRESULT($C00002D3);
  // The power state of the current device cannot support this request.
  STATUS_DS_INVALID_GROUP_TYPE = HRESULT($C00002D4);
  // The specified group type is invalid.
  STATUS_DS_NO_NEST_GLOBALGROUP_IN_MIXEDDOMAIN = HRESULT($C00002D5);
  // In a mixed domain, no nesting of a global group if the group is security enabled.
  STATUS_DS_NO_NEST_LOCALGROUP_IN_MIXEDDOMAIN = HRESULT($C00002D6);
  // In a mixed domain, cannot nest local groups with other local groups, if the group is security enabled.
  STATUS_DS_GLOBAL_CANT_HAVE_LOCAL_MEMBER = HRESULT($C00002D7);
  // A global group cannot have a local group as a member.
  STATUS_DS_GLOBAL_CANT_HAVE_UNIVERSAL_MEMBER = HRESULT($C00002D8);
  // A global group cannot have a universal group as a member.
  STATUS_DS_UNIVERSAL_CANT_HAVE_LOCAL_MEMBER = HRESULT($C00002D9);
  // A universal group cannot have a local group as a member.
  STATUS_DS_GLOBAL_CANT_HAVE_CROSSDOMAIN_MEMBER = HRESULT($C00002DA);
  // A global group cannot have a cross-domain member.
  STATUS_DS_LOCAL_CANT_HAVE_CROSSDOMAIN_LOCAL_MEMBER = HRESULT($C00002DB);
  // A local group cannot have another cross-domain local group as a member.
  STATUS_DS_HAVE_PRIMARY_MEMBERS = HRESULT($C00002DC);
  // Cannot change to a security-disabled group because primary members are in this group.
  STATUS_WMI_NOT_SUPPORTED = HRESULT($C00002DD);
  // The WMI operation is not supported by the data block or method.
  STATUS_INSUFFICIENT_POWER = HRESULT($C00002DE);
  // There is not enough power to complete the requested operation.
  STATUS_SAM_NEED_BOOTKEY_PASSWORD = HRESULT($C00002DF);
  // The Security Accounts Manager needs to get the boot password.
  STATUS_SAM_NEED_BOOTKEY_FLOPPY = HRESULT($C00002E0);
  // The Security Accounts Manager needs to get the boot key from the floppy disk.
  STATUS_DS_CANT_START   = HRESULT($C00002E1); // The directory service cannot start.
  STATUS_DS_INIT_FAILURE = HRESULT($C00002E2);
  // The directory service could not start because of the following error: %hs Error Status: $%x. Click OK to shut down this system and restart in Directory Services Restore Mode. Check the event log for more detailed information.
  STATUS_SAM_INIT_FAILURE = HRESULT($C00002E3);
  // The Security Accounts Manager initialization failed because of the following error: %hs Error Status: $%x. Click OK to shut down this system and restart in Safe Mode. Check the event log for more detailed information.
  STATUS_DS_GC_REQUIRED = HRESULT($C00002E4);
  // The requested operation can be performed only on a global catalog server.
  STATUS_DS_LOCAL_MEMBER_OF_LOCAL_ONLY = HRESULT($C00002E5);
  // A local group can only be a member of other local groups in the same domain.
  STATUS_DS_NO_FPO_IN_UNIVERSAL_GROUPS = HRESULT($C00002E6);
  // Foreign security principals cannot be members of universal groups.
  STATUS_DS_MACHINE_ACCOUNT_QUOTA_EXCEEDED = HRESULT($C00002E7);
  // Your computer could not be joined to the domain. You have exceeded the maximum number of computer accounts you are allowed to create in this domain. Contact your system administrator to have this limit reset or increased.
  STATUS_CURRENT_DOMAIN_NOT_ALLOWED = HRESULT($C00002E9);
  // This operation cannot be performed on the current domain.
  STATUS_CANNOT_MAKE = HRESULT($C00002EA); // The directory or file cannot be created.
  STATUS_SYSTEM_SHUTDOWN = HRESULT($C00002EB);
  // The system is in the process of shutting down.
  STATUS_DS_INIT_FAILURE_CONSOLE = HRESULT($C00002EC);
  // Directory Services could not start because of the following error: %hs Error Status: $%x. Click OK to shut down the system. You can use the recovery console to diagnose the system further.
  STATUS_DS_SAM_INIT_FAILURE_CONSOLE = HRESULT($C00002ED);
  // Security Accounts Manager initialization failed because of the following error: %hs Error Status: $%x. Click OK to shut down the system. You can use the recovery console to diagnose the system further.
  STATUS_UNFINISHED_CONTEXT_DELETED = HRESULT($C00002EE);
  // A security context was deleted before the context was completed. This is considered a logon failure.
  STATUS_NO_TGT_REPLY = HRESULT($C00002EF);
  // The client is trying to negotiate a context and the server requires user-to-user but did not send a TGT reply.
  STATUS_OBJECTID_NOT_FOUND = HRESULT($C00002F0);
  // An object ID was not found in the file.
  STATUS_NO_IP_ADDRESSES = HRESULT($C00002F1);
  // Unable to accomplish the requested task because the local machine does not have any IP addresses.
  STATUS_WRONG_CREDENTIAL_HANDLE = HRESULT($C00002F2);
  // The supplied credential handle does not match the credential that is associated with the security context.
  STATUS_CRYPTO_SYSTEM_INVALID = HRESULT($C00002F3);
  // The crypto system or checksum function is invalid because a required function is unavailable.
  STATUS_MAX_REFERRALS_EXCEEDED = HRESULT($C00002F4);
  // The number of maximum ticket referrals has been exceeded.
  STATUS_MUST_BE_KDC = HRESULT($C00002F5);
  // The local machine must be a Kerberos KDC (domain controller) and it is not.
  STATUS_STRONG_CRYPTO_NOT_SUPPORTED = HRESULT($C00002F6);
  // The other end of the security negotiation requires strong crypto but it is not supported on the local machine.
  STATUS_TOO_MANY_PRINCIPALS = HRESULT($C00002F7);
  // The KDC reply contained more than one principal name.
  STATUS_NO_PA_DATA = HRESULT($C00002F8);
  // Expected to find PA data for a hint of what etype to use, but it was not found.
  STATUS_PKINIT_NAME_MISMATCH = HRESULT($C00002F9);
  // The client certificate does not contain a valid UPN, or does not match the client name in the logon request. Contact your administrator.
  STATUS_SMARTCARD_LOGON_REQUIRED = HRESULT($C00002FA);
  // Smart card logon is required and was not used.
  STATUS_KDC_INVALID_REQUEST = HRESULT($C00002FB);
  // An invalid request was sent to the KDC.
  STATUS_KDC_UNABLE_TO_REFER = HRESULT($C00002FC);
  // The KDC was unable to generate a referral for the service requested.
  STATUS_KDC_UNKNOWN_ETYPE = HRESULT($C00002FD);
  // The encryption type requested is not supported by the KDC.
  STATUS_SHUTDOWN_IN_PROGRESS = HRESULT($C00002FE); // A system shutdown is in progress.
  STATUS_SERVER_SHUTDOWN_IN_PROGRESS = HRESULT($C00002FF);
  // The server machine is shutting down.
  STATUS_NOT_SUPPORTED_ON_SBS = HRESULT($C0000300);
  // This operation is not supported on a computer running Windows Server 2003 operating system for Small Business Server.
  STATUS_WMI_GUID_DISCONNECTED = HRESULT($C0000301);
  // The WMI GUID is no longer available.
  STATUS_WMI_ALREADY_DISABLED = HRESULT($C0000302);
  // Collection or events for the WMI GUID is already disabled.
  STATUS_WMI_ALREADY_ENABLED = HRESULT($C0000303);
  // Collection or events for the WMI GUID is already enabled.
  STATUS_MFT_TOO_FRAGMENTED = HRESULT($C0000304);
  // The master file table on the volume is too fragmented to complete this operation.
  STATUS_COPY_PROTECTION_FAILURE    = HRESULT($C0000305); // Copy protection failure.
  STATUS_CSS_AUTHENTICATION_FAILURE = HRESULT($C0000306);
  // Copy protection error�DVD CSS Authentication failed.
  STATUS_CSS_KEY_NOT_PRESENT = HRESULT($C0000307);
  // Copy protection error�The specified sector does not contain a valid key.
  STATUS_CSS_KEY_NOT_ESTABLISHED = HRESULT($C0000308);
  // Copy protection error�DVD session key not established.
  STATUS_CSS_SCRAMBLED_SECTOR = HRESULT($C0000309);
  // Copy protection error�The read failed because the sector is encrypted.
  STATUS_CSS_REGION_MISMATCH = HRESULT($C000030A);
  // Copy protection error�The region of the specified DVD does not correspond to the region setting of the drive.
  STATUS_CSS_RESETS_EXHAUSTED = HRESULT($C000030B);
  // Copy protection error�The region setting of the drive might be permanent.
  STATUS_PKINIT_FAILURE = HRESULT($C0000320);
  // The Kerberos protocol encountered an error while validating the KDC certificate during smart card logon. There is more information in the system event log.
  STATUS_SMARTCARD_SUBSYSTEM_FAILURE = HRESULT($C0000321);
  // The Kerberos protocol encountered an error while attempting to use the smart card subsystem.
  STATUS_NO_KERB_KEY = HRESULT($C0000322);
  // The target server does not have acceptable Kerberos credentials.
  STATUS_HOST_DOWN = HRESULT($C0000350);
  // The transport determined that the remote system is down.
  STATUS_UNSUPPORTED_PREAUTH = HRESULT($C0000351);
  // An unsupported pre-authentication mechanism was presented to the Kerberos package.
  STATUS_EFS_ALG_BLOB_TOO_BIG = HRESULT($C0000352);
  // The encryption algorithm that is used on the source file needs a bigger key buffer than the one that is used on the destination file.
  STATUS_PORT_NOT_SET = HRESULT($C0000353);
  // An attempt to remove a processes DebugPort was made, but a port was not already associated with the process.
  STATUS_DEBUGGER_INACTIVE = HRESULT($C0000354);
  // An attempt to do an operation on a debug port failed because the port is in the process of being deleted.
  STATUS_DS_VERSION_CHECK_FAILURE = HRESULT($C0000355);
  // This version of Windows is not compatible with the behavior version of the directory forest, domain, or domain controller.
  STATUS_AUDITING_DISABLED = HRESULT($C0000356);
  // The specified event is currently not being audited.
  STATUS_PRENT4_MACHINE_ACCOUNT = HRESULT($C0000357);
  // The machine account was created prior to Windows NT 4.0 operating system. The account needs to be recreated.
  STATUS_DS_AG_CANT_HAVE_UNIVERSAL_MEMBER = HRESULT($C0000358);
  // An account group cannot have a universal group as a member.
  STATUS_INVALID_IMAGE_WIN_32 = HRESULT($C0000359);
  // The specified image file did not have the correct format); it appears to be a 32-bit Windows image.
  STATUS_INVALID_IMAGE_WIN_64 = HRESULT($C000035A);
  // The specified image file did not have the correct format); it appears to be a 64-bit Windows image.
  STATUS_BAD_BINDINGS = HRESULT($C000035B);
  // The client's supplied SSPI channel bindings were incorrect.
  STATUS_NETWORK_SESSION_EXPIRED = HRESULT($C000035C);
  // The client session has expired); so the client must re-authenticate to continue accessing the remote resources.
  STATUS_APPHELP_BLOCK = HRESULT($C000035D);
  // The AppHelp dialog box canceled); thus preventing the application from starting.
  STATUS_ALL_SIDS_FILTERED = HRESULT($C000035E);
  // The SID filtering operation removed all SIDs.
  STATUS_NOT_SAFE_MODE_DRIVER = HRESULT($C000035F);
  // The driver was not loaded because the system is starting in safe mode.
  STATUS_ACCESS_DISABLED_BY_POLICY_DEFAULT = HRESULT($C0000361);
  // Access to %1 has been restricted by your Administrator by the default software restriction policy level.
  STATUS_ACCESS_DISABLED_BY_POLICY_PATH = HRESULT($C0000362);
  // Access to %1 has been restricted by your Administrator by location with policy rule %2 placed on path %3.
  STATUS_ACCESS_DISABLED_BY_POLICY_PUBLISHER = HRESULT($C0000363);
  // Access to %1 has been restricted by your Administrator by software publisher policy.
  STATUS_ACCESS_DISABLED_BY_POLICY_OTHER = HRESULT($C0000364);
  // Access to %1 has been restricted by your Administrator by policy rule %2.
  STATUS_FAILED_DRIVER_ENTRY = HRESULT($C0000365);
  // The driver was not loaded because it failed its initialization call.
  STATUS_DEVICE_ENUMERATION_ERROR = HRESULT($C0000366);
  // The device encountered an error while applying power or reading the device configuration. This might be caused by a failure of your hardware or by a poor connection.
  STATUS_MOUNT_POINT_NOT_RESOLVED = HRESULT($C0000368);
  // The create operation failed because the name contained at least one mount point that resolves to a volume to which the specified device object is not attached.
  STATUS_INVALID_DEVICE_OBJECT_PARAMETER = HRESULT($C0000369);
  // The device object parameter is either not a valid device object or is not attached to the volume that is specified by the file name.
  STATUS_MCA_OCCURED = HRESULT($C000036A);
  // A machine check error has occurred. Check the system event log for additional information.
  STATUS_DRIVER_BLOCKED_CRITICAL = HRESULT($C000036B);
  // Driver %2 has been blocked from loading.
  STATUS_DRIVER_BLOCKED = HRESULT($C000036C); // Driver %2 has been blocked from loading.
  STATUS_DRIVER_DATABASE_ERROR = HRESULT($C000036D);
  // There was error [%2] processing the driver database.
  STATUS_SYSTEM_HIVE_TOO_LARGE = HRESULT($C000036E);
  // System hive size has exceeded its limit.
  STATUS_INVALID_IMPORT_OF_NON_DLL = HRESULT($C000036F);
  // A dynamic link library (DLL) referenced a module that was neither a DLL nor the process's executable image.
  STATUS_NO_SECRETS = HRESULT($C0000371);
  // The local account store does not contain secret material for the specified account.
  STATUS_ACCESS_DISABLED_NO_SAFER_UI_BY_POLICY = HRESULT($C0000372);
  // Access to %1 has been restricted by your Administrator by policy rule %2.
  STATUS_FAILED_STACK_SWITCH = HRESULT($C0000373);
  // The system was not able to allocate enough memory to perform a stack switch.
  STATUS_HEAP_CORRUPTION     = HRESULT($C0000374); // A heap has been corrupted.
  STATUS_SMARTCARD_WRONG_PIN = HRESULT($C0000380);
  // An incorrect PIN was presented to the smart card.
  STATUS_SMARTCARD_CARD_BLOCKED = HRESULT($C0000381); // The smart card is blocked.
  STATUS_SMARTCARD_CARD_NOT_AUTHENTICATED = HRESULT($C0000382);
  // No PIN was presented to the smart card.
  STATUS_SMARTCARD_NO_CARD          = HRESULT($C0000383); // No smart card is available.
  STATUS_SMARTCARD_NO_KEY_CONTAINER = HRESULT($C0000384);
  // The requested key container does not exist on the smart card.
  STATUS_SMARTCARD_NO_CERTIFICATE = HRESULT($C0000385);
  // The requested certificate does not exist on the smart card.
  STATUS_SMARTCARD_NO_KEYSET = HRESULT($C0000386);
  // The requested keyset does not exist.
  STATUS_SMARTCARD_IO_ERROR = HRESULT($C0000387);
  // A communication error with the smart card has been detected.
  STATUS_DOWNGRADE_DETECTED = HRESULT($C0000388);
  // The system detected a possible attempt to compromise security. Ensure that you can contact the server that authenticated you.
  STATUS_SMARTCARD_CERT_REVOKED = HRESULT($C0000389);
  // The smart card certificate used for authentication has been revoked. Contact your system administrator. There might be additional information in the event log.
  STATUS_ISSUING_CA_UNTRUSTED = HRESULT($C000038A);
  // An untrusted certificate authority was detected while processing the smart card certificate that is used for authentication. Contact your system administrator.
  STATUS_REVOCATION_OFFLINE_C = HRESULT($C000038B);
  // The revocation status of the smart card certificate that is used for authentication could not be determined. Contact your system administrator.
  STATUS_PKINIT_CLIENT_FAILURE = HRESULT($C000038C);
  // The smart card certificate used for authentication was not trusted. Contact your system administrator.
  STATUS_SMARTCARD_CERT_EXPIRED = HRESULT($C000038D);
  // The smart card certificate used for authentication has expired. Contact your system administrator.
  STATUS_DRIVER_FAILED_PRIOR_UNLOAD = HRESULT($C000038E);
  // The driver could not be loaded because a previous version of the driver is still in memory.
  STATUS_SMARTCARD_SILENT_CONTEXT = HRESULT($C000038F);
  // The smart card provider could not perform the action because the context was acquired as silent.
  STATUS_PER_USER_TRUST_QUOTA_EXCEEDED = HRESULT($C0000401);
  // The delegated trust creation quota of the current user has been exceeded.
  STATUS_ALL_USER_TRUST_QUOTA_EXCEEDED = HRESULT($C0000402);
  // The total delegated trust creation quota has been exceeded.
  STATUS_USER_DELETE_TRUST_QUOTA_EXCEEDED = HRESULT($C0000403);
  // The delegated trust deletion quota of the current user has been exceeded.
  STATUS_DS_NAME_NOT_UNIQUE = HRESULT($C0000404);
  // The requested name already exists as a unique identifier.
  STATUS_DS_DUPLICATE_ID_FOUND = HRESULT($C0000405);
  // The requested object has a non-unique identifier and cannot be retrieved.
  STATUS_DS_GROUP_CONVERSION_ERROR = HRESULT($C0000406);
  // The group cannot be converted due to attribute restrictions on the requested group type.
  STATUS_VOLSNAP_PREPARE_HIBERNATE = HRESULT($C0000407);
  // {Volume Shadow Copy Service} Wait while the Volume Shadow Copy Service prepares volume %hs for hibernation.
  STATUS_USER2USER_REQUIRED = HRESULT($C0000408);
  // Kerberos sub-protocol User2User is required.
  STATUS_STACK_BUFFER_OVERRUN = HRESULT($C0000409);
  // The system detected an overrun of a stack-based buffer in this application. This overrun could potentially allow a malicious user to gain control of this application.
  STATUS_NO_S4U_PROT_SUPPORT = HRESULT($C000040A);
  // The Kerberos subsystem encountered an error. A service for user protocol request was made against a domain controller which does not support service for user.
  STATUS_CROSSREALM_DELEGATION_FAILURE = HRESULT($C000040B);
  // An attempt was made by this server to make a Kerberos constrained delegation request for a target that is outside the server realm. This action is not supported and the resulting error indicates a misconfiguration on the allowed-to-delegate-to list for this server. Contact your administrator.
  STATUS_REVOCATION_OFFLINE_KDC = HRESULT($C000040C);
  // The revocation status of the domain controller certificate used for smart card authentication could not be determined. There is additional information in the system event log. Contact your system administrator.
  STATUS_ISSUING_CA_UNTRUSTED_KDC = HRESULT($C000040D);
  // An untrusted certificate authority was detected while processing the domain controller certificate used for authentication. There is additional information in the system event log. Contact your system administrator.
  STATUS_KDC_CERT_EXPIRED = HRESULT($C000040E);
  // The domain controller certificate used for smart card logon has expired. Contact your system administrator with the contents of your system event log.
  STATUS_KDC_CERT_REVOKED = HRESULT($C000040F);
  // The domain controller certificate used for smart card logon has been revoked. Contact your system administrator with the contents of your system event log.
  STATUS_PARAMETER_QUOTA_EXCEEDED = HRESULT($C0000410);
  // Data present in one of the parameters is more than the function can operate on.
  STATUS_HIBERNATION_FAILURE = HRESULT($C0000411);
  // The system has failed to hibernate (The error code is %hs). Hibernation will be disabled until the system is restarted.
  STATUS_DELAY_LOAD_FAILED = HRESULT($C0000412);
  // An attempt to delay-load a .dll or get a function address in a delay-loaded .dll failed.
  STATUS_AUTHENTICATION_FIREWALL_FAILED = HRESULT($C0000413);
  // Logon Failure: The machine you are logging onto is protected by an authentication firewall. The specified account is not allowed to authenticate to the machine.
  STATUS_VDM_DISALLOWED = HRESULT($C0000414);
  // %hs is a 16-bit application. You do not have permissions to execute 16-bit applications. Check your permissions with your system administrator.
  STATUS_HUNG_DISPLAY_DRIVER_THREAD = HRESULT($C0000415);
  // {Display Driver Stopped Responding} The %hs display driver has stopped working normally. Save your work and reboot the system to restore full display functionality. The next time you reboot the machine a dialog will be displayed giving you a chance to report this failure to Microsoft.
  STATUS_INSUFFICIENT_RESOURCE_FOR_SPECIFIED_SHARED_SECTION_SIZE = HRESULT($C0000416);
  // The Desktop heap encountered an error while allocating session memory. There is more information in the system event log.
  STATUS_INVALID_CRUNTIME_PARAMETER = HRESULT($C0000417);
  // An invalid parameter was passed to a C runtime function.
  STATUS_NTLM_BLOCKED = HRESULT($C0000418);
  // The authentication failed because NTLM was blocked.
  STATUS_DS_SRC_SID_EXISTS_IN_FOREST = HRESULT($C0000419);
  // The source object's SID already exists in destination forest.
  STATUS_DS_DOMAIN_NAME_EXISTS_IN_FOREST = HRESULT($C000041A);
  // The domain name of the trusted domain already exists in the forest.
  STATUS_DS_FLAT_NAME_EXISTS_IN_FOREST = HRESULT($C000041B);
  // The flat name of the trusted domain already exists in the forest.
  STATUS_INVALID_USER_PRINCIPAL_NAME = HRESULT($C000041C);
  // The User Principal Name (UPN) is invalid.
  STATUS_ASSERTION_FAILURE = HRESULT($C0000420); // There has been an assertion failure.
  STATUS_VERIFIER_STOP     = HRESULT($C0000421);
  // Application verifier has found an error in the current process.
  STATUS_CALLBACK_POP_STACK = HRESULT($C0000423); // A user mode unwind is in progress.
  STATUS_INCOMPATIBLE_DRIVER_BLOCKED = HRESULT($C0000424);
  // %2 has been blocked from loading due to incompatibility with this system. Contact your software vendor for a compatible version of the driver.
  STATUS_HIVE_UNLOADED = HRESULT($C0000425);
  // Illegal operation attempted on a registry key which has already been unloaded.
  STATUS_COMPRESSION_DISABLED = HRESULT($C0000426);
  // Compression is disabled for this volume.
  STATUS_FILE_SYSTEM_LIMITATION = HRESULT($C0000427);
  // The requested operation could not be completed due to a file system limitation.
  STATUS_INVALID_IMAGE_HASH = HRESULT($C0000428);
  // The hash for image %hs cannot be found in the system catalogs. The image is likely corrupt or the victim of tampering.
  STATUS_NOT_CAPABLE = HRESULT($C0000429);
  // The implementation is not capable of performing the request.
  STATUS_REQUEST_OUT_OF_SEQUENCE = HRESULT($C000042A);
  // The requested operation is out of order with respect to other operations.
  STATUS_IMPLEMENTATION_LIMIT = HRESULT($C000042B);
  // An operation attempted to exceed an implementation-defined limit.
  STATUS_ELEVATION_REQUIRED = HRESULT($C000042C);
  // The requested operation requires elevation.
  STATUS_NO_SECURITY_CONTEXT = HRESULT($C000042D);
  // The required security context does not exist.
  STATUS_PKU2U_CERT_FAILURE = HRESULT($C000042E);
  // The PKU2U protocol encountered an error while attempting to utilize the associated certificates.
  STATUS_BEYOND_VDL = HRESULT($C0000432);
  // The operation was attempted beyond the valid data length of the file.
  STATUS_ENCOUNTERED_WRITE_IN_PROGRESS = HRESULT($C0000433);
  // The attempted write operation encountered a write already in progress for some portion of the range.
  STATUS_PTE_CHANGED = HRESULT($C0000434);
  // The page fault mappings changed in the middle of processing a fault so the operation must be retried.
  STATUS_PURGE_FAILED = HRESULT($C0000435);
  // The attempt to purge this file from memory failed to purge some or all the data from memory.
  STATUS_CRED_REQUIRES_CONFIRMATION = HRESULT($C0000440);
  // The requested credential requires confirmation.
  STATUS_CS_ENCRYPTION_INVALID_SERVER_RESPONSE = HRESULT($C0000441);
  // The remote server sent an invalid response for a file being opened with Client Side Encryption.
  STATUS_CS_ENCRYPTION_UNSUPPORTED_SERVER = HRESULT($C0000442);
  // Client Side Encryption is not supported by the remote server even though it claims to support it.
  STATUS_CS_ENCRYPTION_EXISTING_ENCRYPTED_FILE = HRESULT($C0000443);
  // File is encrypted and should be opened in Client Side Encryption mode.
  STATUS_CS_ENCRYPTION_NEW_ENCRYPTED_FILE = HRESULT($C0000444);
  // A new encrypted file is being created and a $EFS needs to be provided.
  STATUS_CS_ENCRYPTION_FILE_NOT_CSE = HRESULT($C0000445);
  // The SMB client requested a CSE FSCTL on a non-CSE file.
  STATUS_INVALID_LABEL = HRESULT($C0000446);
  // Indicates a particular Security ID cannot be assigned as the label of an object.
  STATUS_DRIVER_PROCESS_TERMINATED = HRESULT($C0000450);
  // The process hosting the driver for this device has terminated.
  STATUS_AMBIGUOUS_SYSTEM_DEVICE = HRESULT($C0000451);
  // The requested system device cannot be identified due to multiple indistinguishable devices potentially matching the identification criteria.
  STATUS_SYSTEM_DEVICE_NOT_FOUND = HRESULT($C0000452);
  // The requested system device cannot be found.
  STATUS_RESTART_BOOT_APPLICATION = HRESULT($C0000453);
  // This boot application must be restarted.
  STATUS_INSUFFICIENT_NVRAM_RESOURCES = HRESULT($C0000454);
  // Insufficient NVRAM resources exist to complete the API.  A reboot might be required.
  STATUS_NO_RANGES_PROCESSED = HRESULT($C0000460);
  // No ranges for the specified operation were able to be processed.
  STATUS_DEVICE_FEATURE_NOT_SUPPORTED = HRESULT($C0000463);
  // The storage device does not support Offload Write.
  STATUS_DEVICE_UNREACHABLE = HRESULT($C0000464);
  // Data cannot be moved because the source device cannot communicate with the destination device.
  STATUS_INVALID_TOKEN = HRESULT($C0000465);
  // The token representing the data is invalid or expired.
  STATUS_SERVER_UNAVAILABLE = HRESULT($C0000466);
  // The file server is temporarily unavailable.
  STATUS_INVALID_TASK_NAME = HRESULT($C0000500); // The specified task name is invalid.
  STATUS_INVALID_TASK_INDEX = HRESULT($C0000501); // The specified task index is invalid.
  STATUS_THREAD_ALREADY_IN_TASK = HRESULT($C0000502);
  // The specified thread is already joining a task.
  STATUS_CALLBACK_BYPASS = HRESULT($C0000503);
  // A callback has requested to bypass native code.
  STATUS_FAIL_FAST_EXCEPTION = HRESULT($C0000602);
  // A fail fast exception occurred. Exception handlers will not be invoked and the process will be terminated immediately.
  STATUS_IMAGE_CERT_REVOKED = HRESULT($C0000603);
  // Windows cannot verify the digital signature for this file. The signing certificate for this file has been revoked.
  STATUS_PORT_CLOSED  = HRESULT($C0000700); // The ALPC port is closed.
  STATUS_MESSAGE_LOST = HRESULT($C0000701);
  // The ALPC message requested is no longer available.
  STATUS_INVALID_MESSAGE  = HRESULT($C0000702); // The ALPC message supplied is invalid.
  STATUS_REQUEST_CANCELED = HRESULT($C0000703); // The ALPC message has been canceled.
  STATUS_RECURSIVE_DISPATCH = HRESULT($C0000704); // Invalid recursive dispatch attempt.
  STATUS_LPC_RECEIVE_BUFFER_EXPECTED = HRESULT($C0000705);
  // No receive buffer has been supplied in a synchronous request.
  STATUS_LPC_INVALID_CONNECTION_USAGE = HRESULT($C0000706);
  // The connection port is used in an invalid context.
  STATUS_LPC_REQUESTS_NOT_ALLOWED = HRESULT($C0000707);
  // The ALPC port does not accept new request messages.
  STATUS_RESOURCE_IN_USE = HRESULT($C0000708);
  // The resource requested is already in use.
  STATUS_HARDWARE_MEMORY_ERROR = HRESULT($C0000709);
  // The hardware has reported an uncorrectable memory error.
  STATUS_THREADPOOL_HANDLE_EXCEPTION = HRESULT($C000070A);
  // Status $%08x was returned, waiting on handle $%x for wait $%p, in waiter $%p.
  STATUS_THREADPOOL_SET_EVENT_ON_COMPLETION_FAILED = HRESULT($C000070B);
  // After a callback to $%p($%p), a completion call to Set event($%p) failed with status $%08x.
  STATUS_THREADPOOL_RELEASE_SEMAPHORE_ON_COMPLETION_FAILED = HRESULT($C000070C);
  // After a callback to $%p($%p), a completion call to ReleaseSemaphore($%p, %d) failed with status $%08x.
  STATUS_THREADPOOL_RELEASE_MUTEX_ON_COMPLETION_FAILED = HRESULT($C000070D);
  // After a callback to $%p($%p), a completion call to ReleaseMutex(%p) failed with status $%08x.
  STATUS_THREADPOOL_FREE_LIBRARY_ON_COMPLETION_FAILED = HRESULT($C000070E);
  // After a callback to $%p($%p), a completion call to FreeLibrary(%p) failed with status $%08x.
  STATUS_THREADPOOL_RELEASED_DURING_OPERATION = HRESULT($C000070F);
  // The thread pool $%p was released while a thread was posting a callback to $%p($%p) to it.
  STATUS_CALLBACK_RETURNED_WHILE_IMPERSONATING = HRESULT($C0000710);
  // A thread pool worker thread is impersonating a client, after a callback to $%p($%p). This is unexpected, indicating that the callback is missing a call to revert the impersonation.
  STATUS_APC_RETURNED_WHILE_IMPERSONATING = HRESULT($C0000711);
  // A thread pool worker thread is impersonating a client, after executing an APC. This is unexpected, indicating that the APC is missing a call to revert the impersonation.
  STATUS_PROCESS_IS_PROTECTED = HRESULT($C0000712);
  // Either the target process, or the target thread's containing process, is a protected process.
  STATUS_MCA_EXCEPTION = HRESULT($C0000713);
  // A thread is getting dispatched with MCA EXCEPTION because of MCA.
  STATUS_CERTIFICATE_MAPPING_NOT_UNIQUE = HRESULT($C0000714);
  // The client certificate account mapping is not unique.
  STATUS_SYMLINK_CLASS_DISABLED = HRESULT($C0000715);
  // The symbolic link cannot be followed because its type is disabled.
  STATUS_INVALID_IDN_NORMALIZATION = HRESULT($C0000716);
  // Indicates that the specified string is not valid for IDN normalization.
  STATUS_NO_UNICODE_TRANSLATION = HRESULT($C0000717);
  // No mapping for the Unicode character exists in the target multi-byte code page.
  STATUS_ALREADY_REGISTERED = HRESULT($C0000718);
  // The provided callback is already registered.
  STATUS_CONTEXT_MISMATCH = HRESULT($C0000719);
  // The provided context did not match the target.
  STATUS_PORT_ALREADY_HAS_COMPLETION_LIST = HRESULT($C000071A);
  // The specified port already has a completion list.
  STATUS_CALLBACK_RETURNED_THREAD_PRIORITY = HRESULT($C000071B);
  // A threadpool worker thread entered a callback at thread base priority $%x and exited at priority $%x.  This is unexpected, indicating that the callback missed restoring the priority.
  STATUS_INVALID_THREAD = HRESULT($C000071C);
  // An invalid thread, handle %p, is specified for this operation. Possibly, a threadpool worker thread was specified.
  STATUS_CALLBACK_RETURNED_TRANSACTION = HRESULT($C000071D);
  // A threadpool worker thread entered a callback, which left transaction state.  This is unexpected, indicating that the callback missed clearing the transaction.
  STATUS_CALLBACK_RETURNED_LDR_LOCK = HRESULT($C000071E);
  // A threadpool worker thread entered a callback, which left the loader lock held.  This is unexpected, indicating that the callback missed releasing the lock.
  STATUS_CALLBACK_RETURNED_LANG = HRESULT($C000071F);
  // A threadpool worker thread entered a callback, which left with preferred languages set.  This is unexpected, indicating that the callback missed clearing them.
  STATUS_CALLBACK_RETURNED_PRI_BACK = HRESULT($C0000720);
  // A threadpool worker thread entered a callback, which left with background priorities set.  This is unexpected, indicating that the callback missed restoring the original priorities.
  STATUS_DISK_REPAIR_DISABLED = HRESULT($C0000800);
  // The attempted operation required self healing to be enabled.
  STATUS_DS_DOMAIN_RENAME_IN_PROGRESS = HRESULT($C0000801);
  // The directory service cannot perform the requested operation because a domain rename operation is in progress.
  STATUS_DISK_QUOTA_EXCEEDED = HRESULT($C0000802);
  // An operation failed because the storage quota was exceeded.
  STATUS_CONTENT_BLOCKED = HRESULT($C0000804);
  // An operation failed because the content was blocked.
  STATUS_BAD_CLUSTERS = HRESULT($C0000805);
  // The operation could not be completed due to bad clusters on disk.
  STATUS_VOLUME_DIRTY = HRESULT($C0000806);
  // The operation could not be completed because the volume is dirty. Please run the Chkdsk utility and try again.
  STATUS_FILE_CHECKED_OUT = HRESULT($C0000901);
  // This file is checked out or locked for editing by another user.
  STATUS_CHECKOUT_REQUIRED = HRESULT($C0000902);
  // The file must be checked out before saving changes.
  STATUS_BAD_FILE_TYPE = HRESULT($C0000903);
  // The file type being saved or retrieved has been blocked.
  STATUS_FILE_TOO_LARGE = HRESULT($C0000904);
  // The file size exceeds the limit allowed and cannot be saved.
  STATUS_FORMS_AUTH_REQUIRED = HRESULT($C0000905);
  // Access Denied. Before opening files in this location, you must first browse to the e.g. site and select the option to log on automatically.
  STATUS_VIRUS_INFECTED = HRESULT($C0000906);
  // The operation did not complete successfully because the file contains a virus.
  STATUS_VIRUS_DELETED = HRESULT($C0000907);
  // This file contains a virus and cannot be opened. Due to the nature of this virus, the file has been removed from this location.
  STATUS_BAD_MCFG_TABLE = HRESULT($C0000908);
  // The resources required for this device conflict with the MCFG table.
  STATUS_CANNOT_BREAK_OPLOCK = HRESULT($C0000909);
  // The operation did not complete successfully because it would cause an oplock to be broken. The caller has requested that existing oplocks not be broken.
  STATUS_WOW_ASSERTION     = HRESULT($C0009898); // WOW Assertion Error.
  STATUS_INVALID_SIGNATURE = HRESULT($C000A000);
  // The cryptographic signature is invalid.
  STATUS_HMAC_NOT_SUPPORTED = HRESULT($C000A001);
  // The cryptographic provider does not support HMAC.
  STATUS_IPSEC_QUEUE_OVERFLOW = HRESULT($C000A010); // The IPsec queue overflowed.
  STATUS_ND_QUEUE_OVERFLOW    = HRESULT($C000A011);
  // The neighbor discovery queue overflowed.
  STATUS_HOPLIMIT_EXCEEDED = HRESULT($C000A012);
  // An Internet Control Message Protocol (ICMP) hop limit exceeded error was received.
  STATUS_PROTOCOL_NOT_SUPPORTED = HRESULT($C000A013);
  // The protocol is not installed on the local machine.
  STATUS_LOST_WRITEBEHIND_DATA_NETWORK_DISCONNECTED = HRESULT($C000A080);
  // {Delayed Write Failed} Windows was unable to save all the data for the file %hs); the data has been lost. This error might be caused by network connectivity issues. Try to save this file elsewhere.
  STATUS_LOST_WRITEBEHIND_DATA_NETWORK_SERVER_ERROR = HRESULT($C000A081);
  // {Delayed Write Failed} Windows was unable to save all the data for the file %hs); the data has been lost. This error was returned by the server on which the file exists. Try to save this file elsewhere.
  STATUS_LOST_WRITEBEHIND_DATA_LOCAL_DISK_ERROR = HRESULT($C000A082);
  // {Delayed Write Failed} Windows was unable to save all the data for the file %hs); the data has been lost. This error might be caused if the device has been removed or the media is write-protected.
  STATUS_XML_PARSE_ERROR = HRESULT($C000A083);
  // Windows was unable to parse the requested XML data.
  STATUS_XMLDSIG_ERROR = HRESULT($C000A084);
  // An error was encountered while processing an XML digital signature.
  STATUS_WRONG_COMPARTMENT = HRESULT($C000A085);
  // This indicates that the caller made the connection request in the wrong routing compartment.
  STATUS_AUTHIP_FAILURE = HRESULT($C000A086);
  // This indicates that there was an AuthIP failure when attempting to connect to the remote host.
  STATUS_DS_OID_MAPPED_GROUP_CANT_HAVE_MEMBERS = HRESULT($C000A087);
  // OID mapped groups cannot have members.
  STATUS_DS_OID_NOT_FOUND   = HRESULT($C000A088); // The specified OID cannot be found.
  STATUS_HASH_NOT_SUPPORTED = HRESULT($C000A100);
  // Hash generation for the specified version and hash type is not enabled on server.
  STATUS_HASH_NOT_PRESENT = HRESULT($C000A101);
  // The hash requests is not present or not up to date with the current file contents.
  STATUS_OFFLOAD_READ_FLT_NOT_SUPPORTED = HRESULT($C000A2A1);
  // A file system filter on the server has not opted in for Offload Read support.
  STATUS_OFFLOAD_WRITE_FLT_NOT_SUPPORTED = HRESULT($C000A2A2);
  // A file system filter on the server has not opted in for Offload Write support.
  STATUS_OFFLOAD_READ_FILE_NOT_SUPPORTED = HRESULT($C000A2A3);
  // Offload read operations cannot be performed on:  Compressed files, Sparse files, Encrypted files, File system metadata files
  STATUS_OFFLOAD_WRITE_FILE_NOT_SUPPORTED = HRESULT($C000A2A4);
  // Offload write operations cannot be performed on:  Compressed files, Sparse files, Encrypted files, File system metadata files
  DBG_NO_STATE_CHANGE = HRESULT($C0010001);
  // The debugger did not perform a state change.
  DBG_APP_NOT_IDLE = HRESULT($C0010002);
  // The debugger found that the application is not idle.
  RPC_NT_INVALID_STRING_BINDING = HRESULT($C0020001); // The string binding is invalid.
  RPC_NT_WRONG_KIND_OF_BINDING  = HRESULT($C0020002);
  // The binding handle is not the correct type.
  RPC_NT_INVALID_BINDING       = HRESULT($C0020003); // The binding handle is invalid.
  RPC_NT_PROTSEQ_NOT_SUPPORTED = HRESULT($C0020004);
  // The RPC protocol sequence is not supported.
  RPC_NT_INVALID_RPC_PROTSEQ = HRESULT($C0020005);
  // The RPC protocol sequence is invalid.
  RPC_NT_INVALID_STRING_UUID = HRESULT($C0020006); // The string UUID is invalid.
  RPC_NT_INVALID_ENDPOINT_FORMAT = HRESULT($C0020007); // The endpoint format is invalid.
  RPC_NT_INVALID_NET_ADDR   = HRESULT($C0020008); // The network address is invalid.
  RPC_NT_NO_ENDPOINT_FOUND  = HRESULT($C0020009); // No endpoint was found.
  RPC_NT_INVALID_TIMEOUT    = HRESULT($C002000A); // The time-out value is invalid.
  RPC_NT_OBJECT_NOT_FOUND   = HRESULT($C002000B); // The object UUID was not found.
  RPC_NT_ALREADY_REGISTERED = HRESULT($C002000C);
  // The object UUID has already been registered.
  RPC_NT_TYPE_ALREADY_REGISTERED = HRESULT($C002000D);
  // The type UUID has already been registered.
  RPC_NT_ALREADY_LISTENING = HRESULT($C002000E); // The RPC server is already listening.
  RPC_NT_NO_PROTSEQS_REGISTERED = HRESULT($C002000F);
  // No protocol sequences have been registered.
  RPC_NT_NOT_LISTENING        = HRESULT($C0020010); // The RPC server is not listening.
  RPC_NT_UNKNOWN_MGR_TYPE     = HRESULT($C0020011); // The manager type is unknown.
  RPC_NT_UNKNOWN_IF           = HRESULT($C0020012); // The interface is unknown.
  RPC_NT_NO_BINDINGS          = HRESULT($C0020013); // There are no bindings.
  RPC_NT_NO_PROTSEQS          = HRESULT($C0020014); // There are no protocol sequences.
  RPC_NT_CANT_CREATE_ENDPOINT = HRESULT($C0020015); // The endpoint cannot be created.
  RPC_NT_OUT_OF_RESOURCES     = HRESULT($C0020016);
  // Insufficient resources are available to complete this operation.
  RPC_NT_SERVER_UNAVAILABLE = HRESULT($C0020017); // The RPC server is unavailable.
  RPC_NT_SERVER_TOO_BUSY    = HRESULT($C0020018);
  // The RPC server is too busy to complete this operation.
  RPC_NT_INVALID_NETWORK_OPTIONS = HRESULT($C0020019);
  // The network options are invalid.
  RPC_NT_NO_CALL_ACTIVE  = HRESULT($C002001A); // No RPCs are active on this thread.
  RPC_NT_CALL_FAILED     = HRESULT($C002001B); // The RPC failed.
  RPC_NT_CALL_FAILED_DNE = HRESULT($C002001C); // The RPC failed and did not execute.
  RPC_NT_PROTOCOL_ERROR  = HRESULT($C002001D); // An RPC protocol error occurred.
  RPC_NT_UNSUPPORTED_TRANS_SYN = HRESULT($C002001F);
  // The RPC server does not support the transfer syntax.
  RPC_NT_UNSUPPORTED_TYPE = HRESULT($C0020021); // The type UUID is not supported.
  RPC_NT_INVALID_TAG      = HRESULT($C0020022); // The tag is invalid.
  RPC_NT_INVALID_BOUND    = HRESULT($C0020023); // The array bounds are invalid.
  RPC_NT_NO_ENTRY_NAME    = HRESULT($C0020024);
  // The binding does not contain an entry name.
  RPC_NT_INVALID_NAME_SYNTAX     = HRESULT($C0020025); // The name syntax is invalid.
  RPC_NT_UNSUPPORTED_NAME_SYNTAX = HRESULT($C0020026);
  // The name syntax is not supported.
  RPC_NT_UUID_NO_ADDRESS = HRESULT($C0020028);
  // No network address is available to construct a UUID.
  RPC_NT_DUPLICATE_ENDPOINT = HRESULT($C0020029); // The endpoint is a duplicate.
  RPC_NT_UNKNOWN_AUTHN_TYPE = HRESULT($C002002A); // The authentication type is unknown.
  RPC_NT_MAX_CALLS_TOO_SMALL = HRESULT($C002002B);
  // The maximum number of calls is too small.
  RPC_NT_STRING_TOO_LONG   = HRESULT($C002002C); // The string is too long.
  RPC_NT_PROTSEQ_NOT_FOUND = HRESULT($C002002D);
  // The RPC protocol sequence was not found.
  RPC_NT_PROCNUM_OUT_OF_RANGE = HRESULT($C002002E);
  // The procedure number is out of range.
  RPC_NT_BINDING_HAS_NO_AUTH = HRESULT($C002002F);
  // The binding does not contain any authentication information.
  RPC_NT_UNKNOWN_AUTHN_SERVICE = HRESULT($C0020030);
  // The authentication service is unknown.
  RPC_NT_UNKNOWN_AUTHN_LEVEL = HRESULT($C0020031);
  // The authentication level is unknown.
  RPC_NT_INVALID_AUTH_IDENTITY = HRESULT($C0020032); // The security context is invalid.
  RPC_NT_UNKNOWN_AUTHZ_SERVICE = HRESULT($C0020033);
  // The authorization service is unknown.
  EPT_NT_INVALID_ENTRY   = HRESULT($C0020034); // The entry is invalid.
  EPT_NT_CANT_PERFORM_OP = HRESULT($C0020035); // The operation cannot be performed.
  EPT_NT_NOT_REGISTERED  = HRESULT($C0020036);
  // No more endpoints are available from the endpoint mapper.
  RPC_NT_NOTHING_TO_EXPORT   = HRESULT($C0020037); // No interfaces have been exported.
  RPC_NT_INCOMPLETE_NAME     = HRESULT($C0020038); // The entry name is incomplete.
  RPC_NT_INVALID_VERS_OPTION = HRESULT($C0020039); // The version option is invalid.
  RPC_NT_NO_MORE_MEMBERS     = HRESULT($C002003A); // There are no more members.
  RPC_NT_NOT_ALL_OBJS_UNEXPORTED = HRESULT($C002003B); // There is nothing to unexport.
  RPC_NT_INTERFACE_NOT_FOUND      = HRESULT($C002003C); // The interface was not found.
  RPC_NT_ENTRY_ALREADY_EXISTS     = HRESULT($C002003D); // The entry already exists.
  RPC_NT_ENTRY_NOT_FOUND          = HRESULT($C002003E); // The entry was not found.
  RPC_NT_NAME_SERVICE_UNAVAILABLE = HRESULT($C002003F);
  // The name service is unavailable.
  RPC_NT_INVALID_NAF_ID = HRESULT($C0020040); // The network address family is invalid.
  RPC_NT_CANNOT_SUPPORT = HRESULT($C0020041);
  // The requested operation is not supported.
  RPC_NT_NO_CONTEXT_AVAILABLE = HRESULT($C0020042);
  // No security context is available to allow impersonation.
  RPC_NT_INTERNAL_ERROR = HRESULT($C0020043); // An internal error occurred in the RPC.
  RPC_NT_ZERO_DIVIDE    = HRESULT($C0020044);
  // The RPC server attempted to divide an integer by zero.
  RPC_NT_ADDRESS_ERROR = HRESULT($C0020045);
  // An addressing error occurred in the RPC server.
  RPC_NT_FP_DIV_ZERO = HRESULT($C0020046);
  // A floating point operation at the RPC server caused a divide by zero.
  RPC_NT_FP_UNDERFLOW = HRESULT($C0020047);
  // A floating point underflow occurred at the RPC server.
  RPC_NT_FP_OVERFLOW = HRESULT($C0020048);
  // A floating point overflow occurred at the RPC server.
  RPC_NT_CALL_IN_PROGRESS = HRESULT($C0020049);
  // An RPC is already in progress for this thread.
  RPC_NT_NO_MORE_BINDINGS       = HRESULT($C002004A); // There are no more bindings.
  RPC_NT_GROUP_MEMBER_NOT_FOUND = HRESULT($C002004B); // The group member was not found.
  EPT_NT_CANT_CREATE            = HRESULT($C002004C);
  // The endpoint mapper database entry could not be created.
  RPC_NT_INVALID_OBJECT     = HRESULT($C002004D); // The object UUID is the nil UUID.
  RPC_NT_NO_INTERFACES      = HRESULT($C002004F); // No interfaces have been registered.
  RPC_NT_CALL_CANCELLED     = HRESULT($C0020050); // The RPC was canceled.
  RPC_NT_BINDING_INCOMPLETE = HRESULT($C0020051);
  // The binding handle does not contain all the required information.
  RPC_NT_COMM_FAILURE = HRESULT($C0020052);
  // A communications failure occurred during an RPC.
  RPC_NT_UNSUPPORTED_AUTHN_LEVEL = HRESULT($C0020053);
  // The requested authentication level is not supported.
  RPC_NT_NO_PRINC_NAME = HRESULT($C0020054); // No principal name was registered.
  RPC_NT_NOT_RPC_ERROR = HRESULT($C0020055);
  // The error specified is not a valid Windows RPC error code.
  RPC_NT_SEC_PKG_ERROR = HRESULT($C0020057);
  // A security package-specific error occurred.
  RPC_NT_NOT_CANCELLED        = HRESULT($C0020058); // The thread was not canceled.
  RPC_NT_INVALID_ASYNC_HANDLE = HRESULT($C0020062); // Invalid asynchronous RPC handle.
  RPC_NT_INVALID_ASYNC_CALL   = HRESULT($C0020063);
  // Invalid asynchronous RPC call handle for this operation.
  RPC_NT_PROXY_ACCESS_DENIED = HRESULT($C0020064); // Access to the HTTP proxy is denied.
  RPC_NT_NO_MORE_ENTRIES = HRESULT($C0030001);
  // The list of RPC servers available for auto-handle binding has been exhausted.
  RPC_NT_SS_CHAR_TRANS_OPEN_FAIL = HRESULT($C0030002);
  // The file designated by DCERPCCHARTRANS cannot be opened.
  RPC_NT_SS_CHAR_TRANS_SHORT_FILE = HRESULT($C0030003);
  // The file containing the character translation table has fewer than 512 bytes.
  RPC_NT_SS_IN_NULL_CONTEXT = HRESULT($C0030004);
  // A null context handle is passed as an [in] parameter.
  RPC_NT_SS_CONTEXT_MISMATCH = HRESULT($C0030005);
  // The context handle does not match any known context handles.
  RPC_NT_SS_CONTEXT_DAMAGED = HRESULT($C0030006);
  // The context handle changed during a call.
  RPC_NT_SS_HANDLES_MISMATCH = HRESULT($C0030007);
  // The binding handles passed to an RPC do not match.
  RPC_NT_SS_CANNOT_GET_CALL_HANDLE = HRESULT($C0030008);
  // The stub is unable to get the call handle.
  RPC_NT_NULL_REF_POINTER = HRESULT($C0030009);
  // A null reference pointer was passed to the stub.
  RPC_NT_ENUM_VALUE_OUT_OF_RANGE = HRESULT($C003000A);
  // The enumeration value is out of range.
  RPC_NT_BYTE_COUNT_TOO_SMALL = HRESULT($C003000B); // The byte count is too small.
  RPC_NT_BAD_STUB_DATA        = HRESULT($C003000C); // The stub received bad data.
  RPC_NT_INVALID_ES_ACTION    = HRESULT($C0030059);
  // Invalid operation on the encoding/decoding handle.
  RPC_NT_WRONG_ES_VERSION = HRESULT($C003005A);
  // Incompatible version of the serializing package.
  RPC_NT_WRONG_STUB_VERSION = HRESULT($C003005B);
  // Incompatible version of the RPC stub.
  RPC_NT_INVALID_PIPE_OBJECT = HRESULT($C003005C);
  // The RPC pipe object is invalid or corrupt.
  RPC_NT_INVALID_PIPE_OPERATION = HRESULT($C003005D);
  // An invalid operation was attempted on an RPC pipe object.
  RPC_NT_WRONG_PIPE_VERSION = HRESULT($C003005E); // Unsupported RPC pipe version.
  RPC_NT_PIPE_CLOSED        = HRESULT($C003005F);
  // The RPC pipe object has already been closed.
  RPC_NT_PIPE_DISCIPLINE_ERROR = HRESULT($C0030060);
  // The RPC call completed before all pipes were processed.
  RPC_NT_PIPE_EMPTY = HRESULT($C0030061); // No more data is available from the RPC pipe.
  STATUS_PNP_BAD_MPS_TABLE = HRESULT($C0040035);
  // A device is missing in the system BIOS MPS table. This device will not be used. Contact your system vendor for a system BIOS update.
  STATUS_PNP_TRANSLATION_FAILED = HRESULT($C0040036);
  // A translator failed to translate resources.
  STATUS_PNP_IRQ_TRANSLATION_FAILED = HRESULT($C0040037);
  // An IRQ translator failed to translate resources.
  STATUS_PNP_INVALID_ID = HRESULT($C0040038);
  // Driver %2 returned an invalid ID for a child device (%3).
  STATUS_IO_REISSUE_AS_CACHED = HRESULT($C0040039);
  // Reissue the given operation as a cached I/O operation
  STATUS_CTX_WINSTATION_NAME_INVALID = HRESULT($C00A0001); // Session name %1 is invalid.
  STATUS_CTX_INVALID_PD   = HRESULT($C00A0002); // The protocol driver %1 is invalid.
  STATUS_CTX_PD_NOT_FOUND = HRESULT($C00A0003);
  // The protocol driver %1 was not found in the system path.
  STATUS_CTX_CLOSE_PENDING = HRESULT($C00A0006);
  // A close operation is pending on the terminal connection.
  STATUS_CTX_NO_OUTBUF = HRESULT($C00A0007); // No free output buffers are available.
  STATUS_CTX_MODEM_INF_NOT_FOUND = HRESULT($C00A0008);
  // The MODEM.INF file was not found.
  STATUS_CTX_INVALID_MODEMNAME = HRESULT($C00A0009);
  // The modem (%1) was not found in the MODEM.INF file.
  STATUS_CTX_RESPONSE_ERROR = HRESULT($C00A000A);
  // The modem did not accept the command sent to it. Verify that the configured modem name matches the attached modem.
  STATUS_CTX_MODEM_RESPONSE_TIMEOUT = HRESULT($C00A000B);
  // The modem did not respond to the command sent to it. Verify that the modem cable is properly attached and the modem is turned on.
  STATUS_CTX_MODEM_RESPONSE_NO_CARRIER = HRESULT($C00A000C);
  // Carrier detection has failed or the carrier has been dropped due to disconnection.
  STATUS_CTX_MODEM_RESPONSE_NO_DIALTONE = HRESULT($C00A000D);
  // A dial tone was not detected within the required time. Verify that the phone cable is properly attached and functional.
  STATUS_CTX_MODEM_RESPONSE_BUSY = HRESULT($C00A000E);
  // A busy signal was detected at a remote site on callback.
  STATUS_CTX_MODEM_RESPONSE_VOICE = HRESULT($C00A000F);
  // A voice was detected at a remote site on callback.
  STATUS_CTX_TD_ERROR               = HRESULT($C00A0010); // Transport driver error.
  STATUS_CTX_LICENSE_CLIENT_INVALID = HRESULT($C00A0012);
  // The client you are using is not licensed to use this system. Your logon request is denied.
  STATUS_CTX_LICENSE_NOT_AVAILABLE = HRESULT($C00A0013);
  // The system has reached its licensed logon limit. Try again later.
  STATUS_CTX_LICENSE_EXPIRED = HRESULT($C00A0014);
  // The system license has expired. Your logon request is denied.
  STATUS_CTX_WINSTATION_NOT_FOUND = HRESULT($C00A0015);
  // The specified session cannot be found.
  STATUS_CTX_WINSTATION_NAME_COLLISION = HRESULT($C00A0016);
  // The specified session name is already in use.
  STATUS_CTX_WINSTATION_BUSY = HRESULT($C00A0017);
  // The requested operation cannot be completed because the terminal connection is currently processing a connect, disconnect, reset, or delete operation.
  STATUS_CTX_BAD_VIDEO_MODE = HRESULT($C00A0018);
  // An attempt has been made to connect to a session whose video mode is not supported by the current client.
  STATUS_CTX_GRAPHICS_INVALID = HRESULT($C00A0022);
  // The application attempted to enable DOS graphics mode. DOS graphics mode is not supported.
  STATUS_CTX_NOT_CONSOLE = HRESULT($C00A0024);
  // The requested operation can be performed only on the system console. This is most often the result of a driver or system DLL requiring direct console access.
  STATUS_CTX_CLIENT_QUERY_TIMEOUT = HRESULT($C00A0026);
  // The client failed to respond to the server connect message.
  STATUS_CTX_CONSOLE_DISCONNECT = HRESULT($C00A0027);
  // Disconnecting the console session is not supported.
  STATUS_CTX_CONSOLE_CONNECT = HRESULT($C00A0028);
  // Reconnecting a disconnected session to the console is not supported.
  STATUS_CTX_SHADOW_DENIED = HRESULT($C00A002A);
  // The request to control another session remotely was denied.
  STATUS_CTX_WINSTATION_ACCESS_DENIED = HRESULT($C00A002B);
  // A process has requested access to a session, but has not been granted those access rights.
  STATUS_CTX_INVALID_WD = HRESULT($C00A002E);
  // The terminal connection driver %1 is invalid.
  STATUS_CTX_WD_NOT_FOUND = HRESULT($C00A002F);
  // The terminal connection driver %1 was not found in the system path.
  STATUS_CTX_SHADOW_INVALID = HRESULT($C00A0030);
  // The requested session cannot be controlled remotely. You cannot control your own session, a session that is trying to control your session, a session that has no user logged on, or other sessions from the console.
  STATUS_CTX_SHADOW_DISABLED = HRESULT($C00A0031);
  // The requested session is not configured to allow remote control.
  STATUS_RDP_PROTOCOL_ERROR = HRESULT($C00A0032);
  // The RDP protocol component %2 detected an error in the protocol stream and has disconnected the client.
  STATUS_CTX_CLIENT_LICENSE_NOT_SET = HRESULT($C00A0033);
  // Your request to connect to this terminal server has been rejected. Your terminal server client license number has not been entered for this copy of the terminal client. Contact your system administrator for help in entering a valid, unique license number for this terminal server client. Click OK to continue.
  STATUS_CTX_CLIENT_LICENSE_IN_USE = HRESULT($C00A0034);
  // Your request to connect to this terminal server has been rejected. Your terminal server client license number is currently being used by another user. Contact your system administrator to obtain a new copy of the terminal server client with a valid, unique license number. Click OK to continue.
  STATUS_CTX_SHADOW_ENDED_BY_MODE_CHANGE = HRESULT($C00A0035);
  // The remote control of the console was terminated because the display mode was changed. Changing the display mode in a remote control session is not supported.
  STATUS_CTX_SHADOW_NOT_RUNNING = HRESULT($C00A0036);
  // Remote control could not be terminated because the specified session is not currently being remotely controlled.
  STATUS_CTX_LOGON_DISABLED = HRESULT($C00A0037);
  // Your interactive logon privilege has been disabled. Contact your system administrator.
  STATUS_CTX_SECURITY_LAYER_ERROR = HRESULT($C00A0038);
  // The terminal server security layer detected an error in the protocol stream and has disconnected the client.
  STATUS_TS_INCOMPATIBLE_SESSIONS = HRESULT($C00A0039);
  // The target session is incompatible with the current session.
  STATUS_MUI_FILE_NOT_FOUND = HRESULT($C00B0001);
  // The resource loader failed to find an MUI file.
  STATUS_MUI_INVALID_FILE = HRESULT($C00B0002);
  // The resource loader failed to load an MUI file because the file failed to pass validation.
  STATUS_MUI_INVALID_RC_CONFIG = HRESULT($C00B0003);
  // The RC manifest is corrupted with garbage data, is an unsupported version, or is missing a required item.
  STATUS_MUI_INVALID_LOCALE_NAME = HRESULT($C00B0004);
  // The RC manifest has an invalid culture name.
  STATUS_MUI_INVALID_ULTIMATEFALLBACK_NAME = HRESULT($C00B0005);
  // The RC manifest has and invalid ultimate fallback name.
  STATUS_MUI_FILE_NOT_LOADED = HRESULT($C00B0006);
  // The resource loader cache does not have a loaded MUI entry.
  STATUS_RESOURCE_ENUM_USER_STOP = HRESULT($C00B0007);
  // The user stopped resource enumeration.
  STATUS_CLUSTER_INVALID_NODE = HRESULT($C0130001); // The cluster node is not valid.
  STATUS_CLUSTER_NODE_EXISTS  = HRESULT($C0130002); // The cluster node already exists.
  STATUS_CLUSTER_JOIN_IN_PROGRESS = HRESULT($C0130003);
  // A node is in the process of joining the cluster.
  STATUS_CLUSTER_NODE_NOT_FOUND = HRESULT($C0130004); // The cluster node was not found.
  STATUS_CLUSTER_LOCAL_NODE_NOT_FOUND = HRESULT($C0130005);
  // The cluster local node information was not found.
  STATUS_CLUSTER_NETWORK_EXISTS = HRESULT($C0130006);
  // The cluster network already exists.
  STATUS_CLUSTER_NETWORK_NOT_FOUND = HRESULT($C0130007);
  // The cluster network was not found.
  STATUS_CLUSTER_NETINTERFACE_EXISTS = HRESULT($C0130008);
  // The cluster network interface already exists.
  STATUS_CLUSTER_NETINTERFACE_NOT_FOUND = HRESULT($C0130009);
  // The cluster network interface was not found.
  STATUS_CLUSTER_INVALID_REQUEST = HRESULT($C013000A);
  // The cluster request is not valid for this object.
  STATUS_CLUSTER_INVALID_NETWORK_PROVIDER = HRESULT($C013000B);
  // The cluster network provider is not valid.
  STATUS_CLUSTER_NODE_DOWN        = HRESULT($C013000C); // The cluster node is down.
  STATUS_CLUSTER_NODE_UNREACHABLE = HRESULT($C013000D);
  // The cluster node is not reachable.
  STATUS_CLUSTER_NODE_NOT_MEMBER = HRESULT($C013000E);
  // The cluster node is not a member of the cluster.
  STATUS_CLUSTER_JOIN_NOT_IN_PROGRESS = HRESULT($C013000F);
  // A cluster join operation is not in progress.
  STATUS_CLUSTER_INVALID_NETWORK = HRESULT($C0130010);
  // The cluster network is not valid.
  STATUS_CLUSTER_NO_NET_ADAPTERS = HRESULT($C0130011);
  // No network adapters are available.
  STATUS_CLUSTER_NODE_UP     = HRESULT($C0130012); // The cluster node is up.
  STATUS_CLUSTER_NODE_PAUSED = HRESULT($C0130013); // The cluster node is paused.
  STATUS_CLUSTER_NODE_NOT_PAUSED = HRESULT($C0130014); // The cluster node is not paused.
  STATUS_CLUSTER_NO_SECURITY_CONTEXT = HRESULT($C0130015);
  // No cluster security context is available.
  STATUS_CLUSTER_NETWORK_NOT_INTERNAL = HRESULT($C0130016);
  // The cluster network is not configured for internal cluster communication.
  STATUS_CLUSTER_POISONED = HRESULT($C0130017); // The cluster node has been poisoned.
  STATUS_ACPI_INVALID_OPCODE = HRESULT($C0140001);
  // An attempt was made to run an invalid AML opcode.
  STATUS_ACPI_STACK_OVERFLOW = HRESULT($C0140002);
  // The AML interpreter stack has overflowed.
  STATUS_ACPI_ASSERT_FAILED = HRESULT($C0140003); // An inconsistent state has occurred.
  STATUS_ACPI_INVALID_INDEX = HRESULT($C0140004);
  // An attempt was made to access an array outside its bounds.
  STATUS_ACPI_INVALID_ARGUMENT = HRESULT($C0140005);
  // A required argument was not specified.
  STATUS_ACPI_FATAL             = HRESULT($C0140006); // A fatal error has occurred.
  STATUS_ACPI_INVALID_SUPERNAME = HRESULT($C0140007);
  // An invalid SuperName was specified.
  STATUS_ACPI_INVALID_ARGTYPE = HRESULT($C0140008);
  // An argument with an incorrect type was specified.
  STATUS_ACPI_INVALID_OBJTYPE = HRESULT($C0140009);
  // An object with an incorrect type was specified.
  STATUS_ACPI_INVALID_TARGETTYPE = HRESULT($C014000A);
  // A target with an incorrect type was specified.
  STATUS_ACPI_INCORRECT_ARGUMENT_COUNT = HRESULT($C014000B);
  // An incorrect number of arguments was specified.
  STATUS_ACPI_ADDRESS_NOT_MAPPED = HRESULT($C014000C); // An address failed to translate.
  STATUS_ACPI_INVALID_EVENTTYPE = HRESULT($C014000D);
  // An incorrect event type was specified.
  STATUS_ACPI_HANDLER_COLLISION = HRESULT($C014000E);
  // A handler for the target already exists.
  STATUS_ACPI_INVALID_DATA = HRESULT($C014000F);
  // Invalid data for the target was specified.
  STATUS_ACPI_INVALID_REGION = HRESULT($C0140010);
  // An invalid region for the target was specified.
  STATUS_ACPI_INVALID_ACCESS_SIZE = HRESULT($C0140011);
  // An attempt was made to access a field outside the defined range.
  STATUS_ACPI_ACQUIRE_GLOBAL_LOCK = HRESULT($C0140012);
  // The global system lock could not be acquired.
  STATUS_ACPI_ALREADY_INITIALIZED = HRESULT($C0140013);
  // An attempt was made to reinitialize the ACPI subsystem.
  STATUS_ACPI_NOT_INITIALIZED = HRESULT($C0140014);
  // The ACPI subsystem has not been initialized.
  STATUS_ACPI_INVALID_MUTEX_LEVEL = HRESULT($C0140015);
  // An incorrect mutex was specified.
  STATUS_ACPI_MUTEX_NOT_OWNED = HRESULT($C0140016); // The mutex is not currently owned.
  STATUS_ACPI_MUTEX_NOT_OWNER = HRESULT($C0140017);
  // An attempt was made to access the mutex by a process that was not the owner.
  STATUS_ACPI_RS_ACCESS = HRESULT($C0140018);
  // An error occurred during an access to region space.
  STATUS_ACPI_INVALID_TABLE = HRESULT($C0140019);
  // An attempt was made to use an incorrect table.
  STATUS_ACPI_REG_HANDLER_FAILED = HRESULT($C0140020);
  // The registration of an ACPI event failed.
  STATUS_ACPI_POWER_REQUEST_FAILED = HRESULT($C0140021);
  // An ACPI power object failed to transition state.
  STATUS_SXS_SECTION_NOT_FOUND = HRESULT($C0150001);
  // The requested section is not present in the activation context.
  STATUS_SXS_CANT_GEN_ACTCTX = HRESULT($C0150002);
  // Windows was unble to process the application binding information. Refer to the system event log for further information.
  STATUS_SXS_INVALID_ACTCTXDATA_FORMAT = HRESULT($C0150003);
  // The application binding data format is invalid.
  STATUS_SXS_ASSEMBLY_NOT_FOUND = HRESULT($C0150004);
  // The referenced assembly is not installed on the system.
  STATUS_SXS_MANIFEST_FORMAT_ERROR = HRESULT($C0150005);
  // The manifest file does not begin with the required tag and format information.
  STATUS_SXS_MANIFEST_PARSE_ERROR = HRESULT($C0150006);
  // The manifest file contains one or more syntax errors.
  STATUS_SXS_ACTIVATION_CONTEXT_DISABLED = HRESULT($C0150007);
  // The application attempted to activate a disabled activation context.
  STATUS_SXS_KEY_NOT_FOUND = HRESULT($C0150008);
  // The requested lookup key was not found in any active activation context.
  STATUS_SXS_VERSION_CONFLICT = HRESULT($C0150009);
  // A component version required by the application conflicts with another component version that is already active.
  STATUS_SXS_WRONG_SECTION_TYPE = HRESULT($C015000A);
  // The type requested activation context section does not match the query API used.
  STATUS_SXS_THREAD_QUERIES_DISABLED = HRESULT($C015000B);
  // Lack of system resources has required isolated activation to be disabled for the current thread of execution.
  STATUS_SXS_ASSEMBLY_MISSING = HRESULT($C015000C);
  // The referenced assembly could not be found.
  STATUS_SXS_PROCESS_DEFAULT_ALREADY_SET = HRESULT($C015000E);
  // An attempt to set the process default activation context failed because the process default activation context was already set.
  STATUS_SXS_EARLY_DEACTIVATION = HRESULT($C015000F);
  // The activation context being deactivated is not the most recently activated one.
  STATUS_SXS_INVALID_DEACTIVATION = HRESULT($C0150010);
  // The activation context being deactivated is not active for the current thread of execution.
  STATUS_SXS_MULTIPLE_DEACTIVATION = HRESULT($C0150011);
  // The activation context being deactivated has already been deactivated.
  STATUS_SXS_SYSTEM_DEFAULT_ACTIVATION_CONTEXT_EMPTY = HRESULT($C0150012);
  // The activation context of the system default assembly could not be generated.
  STATUS_SXS_PROCESS_TERMINATION_REQUESTED = HRESULT($C0150013);
  // A component used by the isolation facility has requested that the process be terminated.
  STATUS_SXS_CORRUPT_ACTIVATION_STACK = HRESULT($C0150014);
  // The activation context activation stack for the running thread of execution is corrupt.
  STATUS_SXS_CORRUPTION = HRESULT($C0150015);
  // The application isolation metadata for this process or thread has become corrupt.
  STATUS_SXS_INVALID_IDENTITY_ATTRIBUTE_VALUE = HRESULT($C0150016);
  // The value of an attribute in an identity is not within the legal range.
  STATUS_SXS_INVALID_IDENTITY_ATTRIBUTE_NAME = HRESULT($C0150017);
  // The name of an attribute in an identity is not within the legal range.
  STATUS_SXS_IDENTITY_DUPLICATE_ATTRIBUTE = HRESULT($C0150018);
  // An identity contains two definitions for the same attribute.
  STATUS_SXS_IDENTITY_PARSE_ERROR = HRESULT($C0150019);
  // The identity string is malformed. This might be due to a trailing comma, more than two unnamed attributes, a missing attribute name, or a missing attribute value.
  STATUS_SXS_COMPONENT_STORE_CORRUPT = HRESULT($C015001A);
  // The component store has become corrupted.
  STATUS_SXS_FILE_HASH_MISMATCH = HRESULT($C015001B);
  // A component's file does not match the verification information present in the component manifest.
  STATUS_SXS_MANIFEST_IDENTITY_SAME_BUT_CONTENTS_DIFFERENT = HRESULT($C015001C);
  // The identities of the manifests are identical, but their contents are different.
  STATUS_SXS_IDENTITIES_DIFFERENT = HRESULT($C015001D);
  // The component identities are different.
  STATUS_SXS_ASSEMBLY_IS_NOT_A_DEPLOYMENT = HRESULT($C015001E);
  // The assembly is not a deployment.
  STATUS_SXS_FILE_NOT_PART_OF_ASSEMBLY = HRESULT($C015001F);
  // The file is not a part of the assembly.
  STATUS_ADVANCED_INSTALLER_FAILED = HRESULT($C0150020);
  // An advanced installer failed during setup or servicing.
  STATUS_XML_ENCODING_MISMATCH = HRESULT($C0150021);
  // The character encoding in the XML declaration did not match the encoding used in the document.
  STATUS_SXS_MANIFEST_TOO_BIG = HRESULT($C0150022);
  // The size of the manifest exceeds the maximum allowed.
  STATUS_SXS_SETTING_NOT_REGISTERED = HRESULT($C0150023);
  // The setting is not registered.
  STATUS_SXS_TRANSACTION_CLOSURE_INCOMPLETE = HRESULT($C0150024);
  // One or more required transaction members are not present.
  STATUS_SMI_PRIMITIVE_INSTALLER_FAILED = HRESULT($C0150025);
  // The SMI primitive installer failed during setup or servicing.
  STATUS_GENERIC_COMMAND_FAILED = HRESULT($C0150026);
  // A generic command executable returned a result that indicates failure.
  STATUS_SXS_FILE_HASH_MISSING = HRESULT($C0150027);
  // A component is missing file verification information in its manifest.
  STATUS_TRANSACTIONAL_CONFLICT = HRESULT($C0190001);
  // The function attempted to use a name that is reserved for use by another transaction.
  STATUS_INVALID_TRANSACTION = HRESULT($C0190002);
  // The transaction handle associated with this operation is invalid.
  STATUS_TRANSACTION_NOT_ACTIVE = HRESULT($C0190003);
  // The requested operation was made in the context of a transaction that is no longer active.
  STATUS_TM_INITIALIZATION_FAILED = HRESULT($C0190004);
  // The transaction manager was unable to be successfully initialized. Transacted operations are not supported.
  STATUS_RM_NOT_ACTIVE = HRESULT($C0190005);
  // Transaction support within the specified file system resource manager was not started or was shut down due to an error.
  STATUS_RM_METADATA_CORRUPT = HRESULT($C0190006);
  // The metadata of the resource manager has been corrupted. The resource manager will not function.
  STATUS_TRANSACTION_NOT_JOINED = HRESULT($C0190007);
  // The resource manager attempted to prepare a transaction that it has not successfully joined.
  STATUS_DIRECTORY_NOT_RM = HRESULT($C0190008);
  // The specified directory does not contain a file system resource manager.
  STATUS_TRANSACTIONS_UNSUPPORTED_REMOTE = HRESULT($C019000A);
  // The remote server or share does not support transacted file operations.
  STATUS_LOG_RESIZE_INVALID_SIZE = HRESULT($C019000B);
  // The requested log size for the file system resource manager is invalid.
  STATUS_REMOTE_FILE_VERSION_MISMATCH = HRESULT($C019000C);
  // The remote server sent mismatching version number or Fid for a file opened with transactions.
  STATUS_CRM_PROTOCOL_ALREADY_EXISTS = HRESULT($C019000F);
  // The resource manager tried to register a protocol that already exists.
  STATUS_TRANSACTION_PROPAGATION_FAILED = HRESULT($C0190010);
  // The attempt to propagate the transaction failed.
  STATUS_CRM_PROTOCOL_NOT_FOUND = HRESULT($C0190011);
  // The requested propagation protocol was not registered as a CRM.
  STATUS_TRANSACTION_SUPERIOR_EXISTS = HRESULT($C0190012);
  // The transaction object already has a superior enlistment, and the caller attempted an operation that would have created a new superior. Only a single superior enlistment is allowed.
  STATUS_TRANSACTION_REQUEST_NOT_VALID = HRESULT($C0190013);
  // The requested operation is not valid on the transaction object in its current state.
  STATUS_TRANSACTION_NOT_REQUESTED = HRESULT($C0190014);
  // The caller has called a response API, but the response is not expected because the transaction manager did not issue the corresponding request to the caller.
  STATUS_TRANSACTION_ALREADY_ABORTED = HRESULT($C0190015);
  // It is too late to perform the requested operation, because the transaction has already been aborted.
  STATUS_TRANSACTION_ALREADY_COMMITTED = HRESULT($C0190016);
  // It is too late to perform the requested operation, because the transaction has already been committed.
  STATUS_TRANSACTION_INVALID_MARSHALL_BUFFER = HRESULT($C0190017);
  // The buffer passed in to NtPushTransaction or NtPullTransaction is not in a valid format.
  STATUS_CURRENT_TRANSACTION_NOT_VALID = HRESULT($C0190018);
  // The current transaction context associated with the thread is not a valid handle to a transaction object.
  STATUS_LOG_GROWTH_FAILED = HRESULT($C0190019);
  // An attempt to create space in the transactional resource manager's log failed. The failure status has been recorded in the event log.
  STATUS_OBJECT_NO_LONGER_EXISTS = HRESULT($C0190021);
  // The object (file, stream, or link) that corresponds to the handle has been deleted by a transaction savepoint rollback.
  STATUS_STREAM_MINIVERSION_NOT_FOUND = HRESULT($C0190022);
  // The specified file miniversion was not found for this transacted file open.
  STATUS_STREAM_MINIVERSION_NOT_VALID = HRESULT($C0190023);
  // The specified file miniversion was found but has been invalidated. The most likely cause is a transaction savepoint rollback.
  STATUS_MINIVERSION_INACCESSIBLE_FROM_SPECIFIED_TRANSACTION = HRESULT($C0190024);
  // A miniversion can be opened only in the context of the transaction that created it.
  STATUS_CANT_OPEN_MINIVERSION_WITH_MODIFY_INTENT = HRESULT($C0190025);
  // It is not possible to open a miniversion with modify access.
  STATUS_CANT_CREATE_MORE_STREAM_MINIVERSIONS = HRESULT($C0190026);
  // It is not possible to create any more miniversions for this stream.
  STATUS_HANDLE_NO_LONGER_VALID = HRESULT($C0190028);
  // The handle has been invalidated by a transaction. The most likely cause is the presence of memory mapping on a file or an open handle when the transaction ended or rolled back to savepoint.
  STATUS_LOG_CORRUPTION_DETECTED = HRESULT($C0190030); // The log data is corrupt.
  STATUS_RM_DISCONNECTED         = HRESULT($C0190032);
  // The transaction outcome is unavailable because the resource manager responsible for it is disconnected.
  STATUS_ENLISTMENT_NOT_SUPERIOR = HRESULT($C0190033);
  // The request was rejected because the enlistment in question is not a superior enlistment.
  STATUS_FILE_IDENTITY_NOT_PERSISTENT = HRESULT($C0190036);
  // The file cannot be opened in a transaction because its identity depends on the outcome of an unresolved transaction.
  STATUS_CANT_BREAK_TRANSACTIONAL_DEPENDENCY = HRESULT($C0190037);
  // The operation cannot be performed because another transaction is depending on this property not changing.
  STATUS_CANT_CROSS_RM_BOUNDARY = HRESULT($C0190038);
  // The operation would involve a single file with two transactional resource managers and is, therefore, not allowed.
  STATUS_TXF_DIR_NOT_EMPTY = HRESULT($C0190039);
  // The $Txf directory must be empty for this operation to succeed.
  STATUS_INDOUBT_TRANSACTIONS_EXIST = HRESULT($C019003A);
  // The operation would leave a transactional resource manager in an inconsistent state and is therefore not allowed.
  STATUS_TM_VOLATILE = HRESULT($C019003B);
  // The operation could not be completed because the transaction manager does not have a log.
  STATUS_ROLLBACK_TIMER_EXPIRED = HRESULT($C019003C);
  // A rollback could not be scheduled because a previously scheduled rollback has already executed or been queued for execution.
  STATUS_TXF_ATTRIBUTE_CORRUPT = HRESULT($C019003D);
  // The transactional metadata attribute on the file or directory %hs is corrupt and unreadable.
  STATUS_EFS_NOT_ALLOWED_IN_TRANSACTION = HRESULT($C019003E);
  // The encryption operation could not be completed because a transaction is active.
  STATUS_TRANSACTIONAL_OPEN_NOT_ALLOWED = HRESULT($C019003F);
  // This object is not allowed to be opened in a transaction.
  STATUS_TRANSACTED_MAPPING_UNSUPPORTED_REMOTE = HRESULT($C0190040);
  // Memory mapping (creating a mapped section) a remote file under a transaction is not supported.
  STATUS_TRANSACTION_REQUIRED_PROMOTION = HRESULT($C0190043);
  // Promotion was required to allow the resource manager to enlist, but the transaction was set to disallow it.
  STATUS_CANNOT_EXECUTE_FILE_IN_TRANSACTION = HRESULT($C0190044);
  // This file is open for modification in an unresolved transaction and can be opened for execute only by a transacted reader.
  STATUS_TRANSACTIONS_NOT_FROZEN = HRESULT($C0190045);
  // The request to thaw frozen transactions was ignored because transactions were not previously frozen.
  STATUS_TRANSACTION_FREEZE_IN_PROGRESS = HRESULT($C0190046);
  // Transactions cannot be frozen because a freeze is already in progress.
  STATUS_NOT_SNAPSHOT_VOLUME = HRESULT($C0190047);
  // The target volume is not a snapshot volume. This operation is valid only on a volume mounted as a snapshot.
  STATUS_NO_SAVEPOINT_WITH_OPEN_FILES = HRESULT($C0190048);
  // The savepoint operation failed because files are open on the transaction, which is not permitted.
  STATUS_SPARSE_NOT_ALLOWED_IN_TRANSACTION = HRESULT($C0190049);
  // The sparse operation could not be completed because a transaction is active on the file.
  STATUS_TM_IDENTITY_MISMATCH = HRESULT($C019004A);
  // The call to create a transaction manager object failed because the Tm Identity that is stored in the log file does not match the Tm Identity that was passed in as an argument.
  STATUS_FLOATED_SECTION = HRESULT($C019004B);
  // I/O was attempted on a section object that has been floated as a result of a transaction ending. There is no valid data.
  STATUS_CANNOT_ACCEPT_TRANSACTED_WORK = HRESULT($C019004C);
  // The transactional resource manager cannot currently accept transacted work due to a transient condition, such as low resources.
  STATUS_CANNOT_ABORT_TRANSACTIONS = HRESULT($C019004D);
  // The transactional resource manager had too many transactions outstanding that could not be aborted. The transactional resource manager has been shut down.
  STATUS_TRANSACTION_NOT_FOUND = HRESULT($C019004E);
  // The specified transaction was unable to be opened because it was not found.
  STATUS_RESOURCEMANAGER_NOT_FOUND = HRESULT($C019004F);
  // The specified resource manager was unable to be opened because it was not found.
  STATUS_ENLISTMENT_NOT_FOUND = HRESULT($C0190050);
  // The specified enlistment was unable to be opened because it was not found.
  STATUS_TRANSACTIONMANAGER_NOT_FOUND = HRESULT($C0190051);
  // The specified transaction manager was unable to be opened because it was not found.
  STATUS_TRANSACTIONMANAGER_NOT_ONLINE = HRESULT($C0190052);
  // The specified resource manager was unable to create an enlistment because its associated transaction manager is not online.
  STATUS_TRANSACTIONMANAGER_RECOVERY_NAME_COLLISION = HRESULT($C0190053);
  // The specified transaction manager was unable to create the objects contained in its log file in the Ob namespace. Therefore, the transaction manager was unable to recover.
  STATUS_TRANSACTION_NOT_ROOT = HRESULT($C0190054);
  // The call to create a superior enlistment on this transaction object could not be completed because the transaction object specified for the enlistment is a subordinate branch of the transaction. Only the root of the transaction can be enlisted as a superior.
  STATUS_TRANSACTION_OBJECT_EXPIRED = HRESULT($C0190055);
  // Because the associated transaction manager or resource manager has been closed, the handle is no longer valid.
  STATUS_COMPRESSION_NOT_ALLOWED_IN_TRANSACTION = HRESULT($C0190056);
  // The compression operation could not be completed because a transaction is active on the file.
  STATUS_TRANSACTION_RESPONSE_NOT_ENLISTED = HRESULT($C0190057);
  // The specified operation could not be performed on this superior enlistment because the enlistment was not created with the corresponding completion response in the NotificationMask.
  STATUS_TRANSACTION_RECORD_TOO_LONG = HRESULT($C0190058);
  // The specified operation could not be performed because the record to be logged was too long. This can occur because either there are too many enlistments on this transaction or the combined RecoveryInformation being logged on behalf of those enlistments is too long.
  STATUS_NO_LINK_TRACKING_IN_TRANSACTION = HRESULT($C0190059);
  // The link-tracking operation could not be completed because a transaction is active.
  STATUS_OPERATION_NOT_SUPPORTED_IN_TRANSACTION = HRESULT($C019005A);
  // This operation cannot be performed in a transaction.
  STATUS_TRANSACTION_INTEGRITY_VIOLATED = HRESULT($C019005B);
  // The kernel transaction manager had to abort or forget the transaction because it blocked forward progress.
  STATUS_EXPIRED_HANDLE = HRESULT($C0190060);
  // The handle is no longer properly associated with its transaction.  It might have been opened in a transactional resource manager that was subsequently forced to restart.  Please close the handle and open a new one.
  STATUS_TRANSACTION_NOT_ENLISTED = HRESULT($C0190061);
  // The specified operation could not be performed because the resource manager is not enlisted in the transaction.
  STATUS_LOG_SECTOR_INVALID = HRESULT($C01A0001);
  // The log service found an invalid log sector.
  STATUS_LOG_SECTOR_PARITY_INVALID = HRESULT($C01A0002);
  // The log service encountered a log sector with invalid block parity.
  STATUS_LOG_SECTOR_REMAPPED = HRESULT($C01A0003);
  // The log service encountered a remapped log sector.
  STATUS_LOG_BLOCK_INCOMPLETE = HRESULT($C01A0004);
  // The log service encountered a partial or incomplete log block.
  STATUS_LOG_INVALID_RANGE = HRESULT($C01A0005);
  // The log service encountered an attempt to access data outside the active log range.
  STATUS_LOG_BLOCKS_EXHAUSTED = HRESULT($C01A0006);
  // The log service user-log marshaling buffers are exhausted.
  STATUS_LOG_READ_CONTEXT_INVALID = HRESULT($C01A0007);
  // The log service encountered an attempt to read from a marshaling area with an invalid read context.
  STATUS_LOG_RESTART_INVALID = HRESULT($C01A0008);
  // The log service encountered an invalid log restart area.
  STATUS_LOG_BLOCK_VERSION = HRESULT($C01A0009);
  // The log service encountered an invalid log block version.
  STATUS_LOG_BLOCK_INVALID = HRESULT($C01A000A);
  // The log service encountered an invalid log block.
  STATUS_LOG_READ_MODE_INVALID = HRESULT($C01A000B);
  // The log service encountered an attempt to read the log with an invalid read mode.
  STATUS_LOG_METADATA_CORRUPT = HRESULT($C01A000D);
  // The log service encountered a corrupted metadata file.
  STATUS_LOG_METADATA_INVALID = HRESULT($C01A000E);
  // The log service encountered a metadata file that could not be created by the log file system.
  STATUS_LOG_METADATA_INCONSISTENT = HRESULT($C01A000F);
  // The log service encountered a metadata file with inconsistent data.
  STATUS_LOG_RESERVATION_INVALID = HRESULT($C01A0010);
  // The log service encountered an attempt to erroneously allocate or dispose reservation space.
  STATUS_LOG_CANT_DELETE = HRESULT($C01A0011);
  // The log service cannot delete the log file or the file system container.
  STATUS_LOG_CONTAINER_LIMIT_EXCEEDED = HRESULT($C01A0012);
  // The log service has reached the maximum allowable containers allocated to a log file.
  STATUS_LOG_START_OF_LOG = HRESULT($C01A0013);
  // The log service has attempted to read or write backward past the start of the log.
  STATUS_LOG_POLICY_ALREADY_INSTALLED = HRESULT($C01A0014);
  // The log policy could not be installed because a policy of the same type is already present.
  STATUS_LOG_POLICY_NOT_INSTALLED = HRESULT($C01A0015);
  // The log policy in question was not installed at the time of the request.
  STATUS_LOG_POLICY_INVALID = HRESULT($C01A0016);
  // The installed set of policies on the log is invalid.
  STATUS_LOG_POLICY_CONFLICT = HRESULT($C01A0017);
  // A policy on the log in question prevented the operation from completing.
  STATUS_LOG_PINNED_ARCHIVE_TAIL = HRESULT($C01A0018);
  // The log space cannot be reclaimed because the log is pinned by the archive tail.
  STATUS_LOG_RECORD_NONEXISTENT = HRESULT($C01A0019);
  // The log record is not a record in the log file.
  STATUS_LOG_RECORDS_RESERVED_INVALID = HRESULT($C01A001A);
  // The number of reserved log records or the adjustment of the number of reserved log records is invalid.
  STATUS_LOG_SPACE_RESERVED_INVALID = HRESULT($C01A001B);
  // The reserved log space or the adjustment of the log space is invalid.
  STATUS_LOG_TAIL_INVALID = HRESULT($C01A001C);
  // A new or existing archive tail or the base of the active log is invalid.
  STATUS_LOG_FULL        = HRESULT($C01A001D); // The log space is exhausted.
  STATUS_LOG_MULTIPLEXED = HRESULT($C01A001E);
  // The log is multiplexed); no direct writes to the physical log are allowed.
  STATUS_LOG_DEDICATED = HRESULT($C01A001F);
  // The operation failed because the log is dedicated.
  STATUS_LOG_ARCHIVE_NOT_IN_PROGRESS = HRESULT($C01A0020);
  // The operation requires an archive context.
  STATUS_LOG_ARCHIVE_IN_PROGRESS = HRESULT($C01A0021); // Log archival is in progress.
  STATUS_LOG_EPHEMERAL           = HRESULT($C01A0022);
  // The operation requires a nonephemeral log, but the log is ephemeral.
  STATUS_LOG_NOT_ENOUGH_CONTAINERS = HRESULT($C01A0023);
  // The log must have at least two containers before it can be read from or written to.
  STATUS_LOG_CLIENT_ALREADY_REGISTERED = HRESULT($C01A0024);
  // A log client has already registered on the stream.
  STATUS_LOG_CLIENT_NOT_REGISTERED = HRESULT($C01A0025);
  // A log client has not been registered on the stream.
  STATUS_LOG_FULL_HANDLER_IN_PROGRESS = HRESULT($C01A0026);
  // A request has already been made to handle the log full condition.
  STATUS_LOG_CONTAINER_READ_FAILED = HRESULT($C01A0027);
  // The log service encountered an error when attempting to read from a log container.
  STATUS_LOG_CONTAINER_WRITE_FAILED = HRESULT($C01A0028);
  // The log service encountered an error when attempting to write to a log container.
  STATUS_LOG_CONTAINER_OPEN_FAILED = HRESULT($C01A0029);
  // The log service encountered an error when attempting to open a log container.
  STATUS_LOG_CONTAINER_STATE_INVALID = HRESULT($C01A002A);
  // The log service encountered an invalid container state when attempting a requested action.
  STATUS_LOG_STATE_INVALID = HRESULT($C01A002B);
  // The log service is not in the correct state to perform a requested action.
  STATUS_LOG_PINNED = HRESULT($C01A002C);
  // The log space cannot be reclaimed because the log is pinned.
  STATUS_LOG_METADATA_FLUSH_FAILED = HRESULT($C01A002D);
  // The log metadata flush failed.
  STATUS_LOG_INCONSISTENT_SECURITY = HRESULT($C01A002E);
  // Security on the log and its containers is inconsistent.
  STATUS_LOG_APPENDED_FLUSH_FAILED = HRESULT($C01A002F);
  // Records were appended to the log or reservation changes were made, but the log could not be flushed.
  STATUS_LOG_PINNED_RESERVATION = HRESULT($C01A0030);
  // The log is pinned due to reservation consuming most of the log space. Free some reserved records to make space available.
  STATUS_VIDEO_HUNG_DISPLAY_DRIVER_THREAD = HRESULT($C01B00EA);
  // {Display Driver Stopped Responding} The %hs display driver has stopped working normally. Save your work and reboot the system to restore full display functionality. The next time you reboot the computer, a dialog box will allow you to upload data about this failure to Microsoft.
  STATUS_FLT_NO_HANDLER_DEFINED = HRESULT($C01C0001);
  // A handler was not defined by the filter for this operation.
  STATUS_FLT_CONTEXT_ALREADY_DEFINED = HRESULT($C01C0002);
  // A context is already defined for this object.
  STATUS_FLT_INVALID_ASYNCHRONOUS_REQUEST = HRESULT($C01C0003);
  // Asynchronous requests are not valid for this operation.
  STATUS_FLT_DISALLOW_FAST_IO = HRESULT($C01C0004);
  // This is an internal error code used by the filter manager to determine if a fast I/O operation should be forced down the input/output request packet (IRP) path. Minifilters should never return this value.
  STATUS_FLT_INVALID_NAME_REQUEST = HRESULT($C01C0005);
  // An invalid name request was made. The name requested cannot be retrieved at this time.
  STATUS_FLT_NOT_SAFE_TO_POST_OPERATION = HRESULT($C01C0006);
  // Posting this operation to a worker thread for further processing is not safe at this time because it could lead to a system deadlock.
  STATUS_FLT_NOT_INITIALIZED = HRESULT($C01C0007);
  // The Filter Manager was not initialized when a filter tried to register. Make sure that the Filter Manager is loaded as a driver.
  STATUS_FLT_FILTER_NOT_READY = HRESULT($C01C0008);
  // The filter is not ready for attachment to volumes because it has not finished initializing (FltStartFiltering has not been called).
  STATUS_FLT_POST_OPERATION_CLEANUP = HRESULT($C01C0009);
  // The filter must clean up any operation-specific context at this time because it is being removed from the system before the operation is completed by the lower drivers.
  STATUS_FLT_INTERNAL_ERROR = HRESULT($C01C000A);
  // The Filter Manager had an internal error from which it cannot recover); therefore, the operation has failed. This is usually the result of a filter returning an invalid value from a pre-operation callback.
  STATUS_FLT_DELETING_OBJECT = HRESULT($C01C000B);
  // The object specified for this action is in the process of being deleted); therefore, the action requested cannot be completed at this time.
  STATUS_FLT_MUST_BE_NONPAGED_POOL = HRESULT($C01C000C);
  // A nonpaged pool must be used for this type of context.
  STATUS_FLT_DUPLICATE_ENTRY = HRESULT($C01C000D);
  // A duplicate handler definition has been provided for an operation.
  STATUS_FLT_CBDQ_DISABLED = HRESULT($C01C000E);
  // The callback data queue has been disabled.
  STATUS_FLT_DO_NOT_ATTACH = HRESULT($C01C000F);
  // Do not attach the filter to the volume at this time.
  STATUS_FLT_DO_NOT_DETACH = HRESULT($C01C0010);
  // Do not detach the filter from the volume at this time.
  STATUS_FLT_INSTANCE_ALTITUDE_COLLISION = HRESULT($C01C0011);
  // An instance already exists at this altitude on the volume specified.
  STATUS_FLT_INSTANCE_NAME_COLLISION = HRESULT($C01C0012);
  // An instance already exists with this name on the volume specified.
  STATUS_FLT_FILTER_NOT_FOUND = HRESULT($C01C0013);
  // The system could not find the filter specified.
  STATUS_FLT_VOLUME_NOT_FOUND = HRESULT($C01C0014);
  // The system could not find the volume specified.
  STATUS_FLT_INSTANCE_NOT_FOUND = HRESULT($C01C0015);
  // The system could not find the instance specified.
  STATUS_FLT_CONTEXT_ALLOCATION_NOT_FOUND = HRESULT($C01C0016);
  // No registered context allocation definition was found for the given request.
  STATUS_FLT_INVALID_CONTEXT_REGISTRATION = HRESULT($C01C0017);
  // An invalid parameter was specified during context registration.
  STATUS_FLT_NAME_CACHE_MISS = HRESULT($C01C0018);
  // The name requested was not found in the Filter Manager name cache and could not be retrieved from the file system.
  STATUS_FLT_NO_DEVICE_OBJECT = HRESULT($C01C0019);
  // The requested device object does not exist for the given volume.
  STATUS_FLT_VOLUME_ALREADY_MOUNTED = HRESULT($C01C001A);
  // The specified volume is already mounted.
  STATUS_FLT_ALREADY_ENLISTED = HRESULT($C01C001B);
  // The specified transaction context is already enlisted in a transaction.
  STATUS_FLT_CONTEXT_ALREADY_LINKED = HRESULT($C01C001C);
  // The specified context is already attached to another object.
  STATUS_FLT_NO_WAITER_FOR_REPLY = HRESULT($C01C0020);
  // No waiter is present for the filter's reply to this message.
  STATUS_MONITOR_NO_DESCRIPTOR = HRESULT($C01D0001);
  // A monitor descriptor could not be obtained.
  STATUS_MONITOR_UNKNOWN_DESCRIPTOR_FORMAT = HRESULT($C01D0002);
  // This release does not support the format of the obtained monitor descriptor.
  STATUS_MONITOR_INVALID_DESCRIPTOR_CHECKSUM = HRESULT($C01D0003);
  // The checksum of the obtained monitor descriptor is invalid.
  STATUS_MONITOR_INVALID_STANDARD_TIMING_BLOCK = HRESULT($C01D0004);
  // The monitor descriptor contains an invalid standard timing block.
  STATUS_MONITOR_WMI_DATABLOCK_REGISTRATION_FAILED = HRESULT($C01D0005);
  // WMI data-block registration failed for one of the MSMonitorClass WMI subclasses.
  STATUS_MONITOR_INVALID_SERIAL_NUMBER_MONDSC_BLOCK = HRESULT($C01D0006);
  // The provided monitor descriptor block is either corrupted or does not contain the monitor's detailed serial number.
  STATUS_MONITOR_INVALID_USER_FRIENDLY_MONDSC_BLOCK = HRESULT($C01D0007);
  // The provided monitor descriptor block is either corrupted or does not contain the monitor's user-friendly name.
  STATUS_MONITOR_NO_MORE_DESCRIPTOR_DATA = HRESULT($C01D0008);
  // There is no monitor descriptor data at the specified (offset or size) region.
  STATUS_MONITOR_INVALID_DETAILED_TIMING_BLOCK = HRESULT($C01D0009);
  // The monitor descriptor contains an invalid detailed timing block.
  STATUS_MONITOR_INVALID_MANUFACTURE_DATE = HRESULT($C01D000A);
  // Monitor descriptor contains invalid manufacture date.
  STATUS_GRAPHICS_NOT_EXCLUSIVE_MODE_OWNER = HRESULT($C01E0000);
  // Exclusive mode ownership is needed to create an unmanaged primary allocation.
  STATUS_GRAPHICS_INSUFFICIENT_DMA_BUFFER = HRESULT($C01E0001);
  // The driver needs more DMA buffer space to complete the requested operation.
  STATUS_GRAPHICS_INVALID_DISPLAY_ADAPTER = HRESULT($C01E0002);
  // The specified display adapter handle is invalid.
  STATUS_GRAPHICS_ADAPTER_WAS_RESET = HRESULT($C01E0003);
  // The specified display adapter and all of its state have been reset.
  STATUS_GRAPHICS_INVALID_DRIVER_MODEL = HRESULT($C01E0004);
  // The driver stack does not match the expected driver model.
  STATUS_GRAPHICS_PRESENT_MODE_CHANGED = HRESULT($C01E0005);
  // Present happened but ended up into the changed desktop mode.
  STATUS_GRAPHICS_PRESENT_OCCLUDED = HRESULT($C01E0006);
  // Nothing to present due to desktop occlusion.
  STATUS_GRAPHICS_PRESENT_DENIED = HRESULT($C01E0007);
  // Not able to present due to denial of desktop access.
  STATUS_GRAPHICS_CANNOTCOLORCONVERT = HRESULT($C01E0008);
  // Not able to present with color conversion.
  STATUS_GRAPHICS_PRESENT_REDIRECTION_DISABLED = HRESULT($C01E000B);
  // Present redirection is disabled (desktop windowing management subsystem is off).
  STATUS_GRAPHICS_PRESENT_UNOCCLUDED = HRESULT($C01E000C);
  // Previous exclusive VidPn source owner has released its ownership
  STATUS_GRAPHICS_NO_VIDEO_MEMORY = HRESULT($C01E0100);
  // Not enough video memory is available to complete the operation.
  STATUS_GRAPHICS_CANT_LOCK_MEMORY = HRESULT($C01E0101);
  // Could not probe and lock the underlying memory of an allocation.
  STATUS_GRAPHICS_ALLOCATION_BUSY = HRESULT($C01E0102);
  // The allocation is currently busy.
  STATUS_GRAPHICS_TOO_MANY_REFERENCES = HRESULT($C01E0103);
  // An object being referenced has already reached the maximum reference count and cannot be referenced further.
  STATUS_GRAPHICS_TRY_AGAIN_LATER = HRESULT($C01E0104);
  // A problem could not be solved due to an existing condition. Try again later.
  STATUS_GRAPHICS_TRY_AGAIN_NOW = HRESULT($C01E0105);
  // A problem could not be solved due to an existing condition. Try again now.
  STATUS_GRAPHICS_ALLOCATION_INVALID = HRESULT($C01E0106); // The allocation is invalid.
  STATUS_GRAPHICS_UNSWIZZLING_APERTURE_UNAVAILABLE = HRESULT($C01E0107);
  // No more unswizzling apertures are currently available.
  STATUS_GRAPHICS_UNSWIZZLING_APERTURE_UNSUPPORTED = HRESULT($C01E0108);
  // The current allocation cannot be unswizzled by an aperture.
  STATUS_GRAPHICS_CANT_EVICT_PINNED_ALLOCATION = HRESULT($C01E0109);
  // The request failed because a pinned allocation cannot be evicted.
  STATUS_GRAPHICS_INVALID_ALLOCATION_USAGE = HRESULT($C01E0110);
  // The allocation cannot be used from its current segment location for the specified operation.
  STATUS_GRAPHICS_CANT_RENDER_LOCKED_ALLOCATION = HRESULT($C01E0111);
  // A locked allocation cannot be used in the current command buffer.
  STATUS_GRAPHICS_ALLOCATION_CLOSED = HRESULT($C01E0112);
  // The allocation being referenced has been closed permanently.
  STATUS_GRAPHICS_INVALID_ALLOCATION_INSTANCE = HRESULT($C01E0113);
  // An invalid allocation instance is being referenced.
  STATUS_GRAPHICS_INVALID_ALLOCATION_HANDLE = HRESULT($C01E0114);
  // An invalid allocation handle is being referenced.
  STATUS_GRAPHICS_WRONG_ALLOCATION_DEVICE = HRESULT($C01E0115);
  // The allocation being referenced does not belong to the current device.
  STATUS_GRAPHICS_ALLOCATION_CONTENT_LOST = HRESULT($C01E0116);
  // The specified allocation lost its content.
  STATUS_GRAPHICS_GPU_EXCEPTION_ON_DEVICE = HRESULT($C01E0200);
  // A GPU exception was detected on the given device. The device cannot be scheduled.
  STATUS_GRAPHICS_INVALID_VIDPN_TOPOLOGY = HRESULT($C01E0300);
  // The specified VidPN topology is invalid.
  STATUS_GRAPHICS_VIDPN_TOPOLOGY_NOT_SUPPORTED = HRESULT($C01E0301);
  // The specified VidPN topology is valid but is not supported by this model of the display adapter.
  STATUS_GRAPHICS_VIDPN_TOPOLOGY_CURRENTLY_NOT_SUPPORTED = HRESULT($C01E0302);
  // The specified VidPN topology is valid but is not currently supported by the display adapter due to allocation of its resources.
  STATUS_GRAPHICS_INVALID_VIDPN = HRESULT($C01E0303);
  // The specified VidPN handle is invalid.
  STATUS_GRAPHICS_INVALID_VIDEO_PRESENT_SOURCE = HRESULT($C01E0304);
  // The specified video present source is invalid.
  STATUS_GRAPHICS_INVALID_VIDEO_PRESENT_TARGET = HRESULT($C01E0305);
  // The specified video present target is invalid.
  STATUS_GRAPHICS_VIDPN_MODALITY_NOT_SUPPORTED = HRESULT($C01E0306);
  // The specified VidPN modality is not supported (for example, at least two of the pinned modes are not co-functional).
  STATUS_GRAPHICS_INVALID_VIDPN_SOURCEMODESET = HRESULT($C01E0308);
  // The specified VidPN source mode set is invalid.
  STATUS_GRAPHICS_INVALID_VIDPN_TARGETMODESET = HRESULT($C01E0309);
  // The specified VidPN target mode set is invalid.
  STATUS_GRAPHICS_INVALID_FREQUENCY = HRESULT($C01E030A);
  // The specified video signal frequency is invalid.
  STATUS_GRAPHICS_INVALID_ACTIVE_REGION = HRESULT($C01E030B);
  // The specified video signal active region is invalid.
  STATUS_GRAPHICS_INVALID_TOTAL_REGION = HRESULT($C01E030C);
  // The specified video signal total region is invalid.
  STATUS_GRAPHICS_INVALID_VIDEO_PRESENT_SOURCE_MODE = HRESULT($C01E0310);
  // The specified video present source mode is invalid.
  STATUS_GRAPHICS_INVALID_VIDEO_PRESENT_TARGET_MODE = HRESULT($C01E0311);
  // The specified video present target mode is invalid.
  STATUS_GRAPHICS_PINNED_MODE_MUST_REMAIN_IN_SET = HRESULT($C01E0312);
  // The pinned mode must remain in the set on the VidPN's co-functional modality enumeration.
  STATUS_GRAPHICS_PATH_ALREADY_IN_TOPOLOGY = HRESULT($C01E0313);
  // The specified video present path is already in the VidPN's topology.
  STATUS_GRAPHICS_MODE_ALREADY_IN_MODESET = HRESULT($C01E0314);
  // The specified mode is already in the mode set.
  STATUS_GRAPHICS_INVALID_VIDEOPRESENTSOURCESET = HRESULT($C01E0315);
  // The specified video present source set is invalid.
  STATUS_GRAPHICS_INVALID_VIDEOPRESENTTARGETSET = HRESULT($C01E0316);
  // The specified video present target set is invalid.
  STATUS_GRAPHICS_SOURCE_ALREADY_IN_SET = HRESULT($C01E0317);
  // The specified video present source is already in the video present source set.
  STATUS_GRAPHICS_TARGET_ALREADY_IN_SET = HRESULT($C01E0318);
  // The specified video present target is already in the video present target set.
  STATUS_GRAPHICS_INVALID_VIDPN_PRESENT_PATH = HRESULT($C01E0319);
  // The specified VidPN present path is invalid.
  STATUS_GRAPHICS_NO_RECOMMENDED_VIDPN_TOPOLOGY = HRESULT($C01E031A);
  // The miniport has no recommendation for augmenting the specified VidPN's topology.
  STATUS_GRAPHICS_INVALID_MONITOR_FREQUENCYRANGESET = HRESULT($C01E031B);
  // The specified monitor frequency range set is invalid.
  STATUS_GRAPHICS_INVALID_MONITOR_FREQUENCYRANGE = HRESULT($C01E031C);
  // The specified monitor frequency range is invalid.
  STATUS_GRAPHICS_FREQUENCYRANGE_NOT_IN_SET = HRESULT($C01E031D);
  // The specified frequency range is not in the specified monitor frequency range set.
  STATUS_GRAPHICS_FREQUENCYRANGE_ALREADY_IN_SET = HRESULT($C01E031F);
  // The specified frequency range is already in the specified monitor frequency range set.
  STATUS_GRAPHICS_STALE_MODESET = HRESULT($C01E0320);
  // The specified mode set is stale. Reacquire the new mode set.
  STATUS_GRAPHICS_INVALID_MONITOR_SOURCEMODESET = HRESULT($C01E0321);
  // The specified monitor source mode set is invalid.
  STATUS_GRAPHICS_INVALID_MONITOR_SOURCE_MODE = HRESULT($C01E0322);
  // The specified monitor source mode is invalid.
  STATUS_GRAPHICS_NO_RECOMMENDED_FUNCTIONAL_VIDPN = HRESULT($C01E0323);
  // The miniport does not have a recommendation regarding the request to provide a functional VidPN given the current display adapter configuration.
  STATUS_GRAPHICS_MODE_ID_MUST_BE_UNIQUE = HRESULT($C01E0324);
  // The ID of the specified mode is being used by another mode in the set.
  STATUS_GRAPHICS_EMPTY_ADAPTER_MONITOR_MODE_SUPPORT_INTERSECTION = HRESULT($C01E0325);
  // The system failed to determine a mode that is supported by both the display adapter and the monitor connected to it.
  STATUS_GRAPHICS_VIDEO_PRESENT_TARGETS_LESS_THAN_SOURCES = HRESULT($C01E0326);
  // The number of video present targets must be greater than or equal to the number of video present sources.
  STATUS_GRAPHICS_PATH_NOT_IN_TOPOLOGY = HRESULT($C01E0327);
  // The specified present path is not in the VidPN's topology.
  STATUS_GRAPHICS_ADAPTER_MUST_HAVE_AT_LEAST_ONE_SOURCE = HRESULT($C01E0328);
  // The display adapter must have at least one video present source.
  STATUS_GRAPHICS_ADAPTER_MUST_HAVE_AT_LEAST_ONE_TARGET = HRESULT($C01E0329);
  // The display adapter must have at least one video present target.
  STATUS_GRAPHICS_INVALID_MONITORDESCRIPTORSET = HRESULT($C01E032A);
  // The specified monitor descriptor set is invalid.
  STATUS_GRAPHICS_INVALID_MONITORDESCRIPTOR = HRESULT($C01E032B);
  // The specified monitor descriptor is invalid.
  STATUS_GRAPHICS_MONITORDESCRIPTOR_NOT_IN_SET = HRESULT($C01E032C);
  // The specified descriptor is not in the specified monitor descriptor set.
  STATUS_GRAPHICS_MONITORDESCRIPTOR_ALREADY_IN_SET = HRESULT($C01E032D);
  // The specified descriptor is already in the specified monitor descriptor set.
  STATUS_GRAPHICS_MONITORDESCRIPTOR_ID_MUST_BE_UNIQUE = HRESULT($C01E032E);
  // The ID of the specified monitor descriptor is being used by another descriptor in the set.
  STATUS_GRAPHICS_INVALID_VIDPN_TARGET_SUBSET_TYPE = HRESULT($C01E032F);
  // The specified video present target subset type is invalid.
  STATUS_GRAPHICS_RESOURCES_NOT_RELATED = HRESULT($C01E0330);
  // Two or more of the specified resources are not related to each other, as defined by the interface semantics.
  STATUS_GRAPHICS_SOURCE_ID_MUST_BE_UNIQUE = HRESULT($C01E0331);
  // The ID of the specified video present source is being used by another source in the set.
  STATUS_GRAPHICS_TARGET_ID_MUST_BE_UNIQUE = HRESULT($C01E0332);
  // The ID of the specified video present target is being used by another target in the set.
  STATUS_GRAPHICS_NO_AVAILABLE_VIDPN_TARGET = HRESULT($C01E0333);
  // The specified VidPN source cannot be used because there is no available VidPN target to connect it to.
  STATUS_GRAPHICS_MONITOR_COULD_NOT_BE_ASSOCIATED_WITH_ADAPTER = HRESULT($C01E0334);
  // The newly arrived monitor could not be associated with a display adapter.
  STATUS_GRAPHICS_NO_VIDPNMGR = HRESULT($C01E0335);
  // The particular display adapter does not have an associated VidPN manager.
  STATUS_GRAPHICS_NO_ACTIVE_VIDPN = HRESULT($C01E0336);
  // The VidPN manager of the particular display adapter does not have an active VidPN.
  STATUS_GRAPHICS_STALE_VIDPN_TOPOLOGY = HRESULT($C01E0337);
  // The specified VidPN topology is stale); obtain the new topology.
  STATUS_GRAPHICS_MONITOR_NOT_CONNECTED = HRESULT($C01E0338);
  // No monitor is connected on the specified video present target.
  STATUS_GRAPHICS_SOURCE_NOT_IN_TOPOLOGY = HRESULT($C01E0339);
  // The specified source is not part of the specified VidPN's topology.
  STATUS_GRAPHICS_INVALID_PRIMARYSURFACE_SIZE = HRESULT($C01E033A);
  // The specified primary surface size is invalid.
  STATUS_GRAPHICS_INVALID_VISIBLEREGION_SIZE = HRESULT($C01E033B);
  // The specified visible region size is invalid.
  STATUS_GRAPHICS_INVALID_STRIDE = HRESULT($C01E033C);
  // The specified stride is invalid.
  STATUS_GRAPHICS_INVALID_PIXELFORMAT = HRESULT($C01E033D);
  // The specified pixel format is invalid.
  STATUS_GRAPHICS_INVALID_COLORBASIS = HRESULT($C01E033E);
  // The specified color basis is invalid.
  STATUS_GRAPHICS_INVALID_PIXELVALUEACCESSMODE = HRESULT($C01E033F);
  // The specified pixel value access mode is invalid.
  STATUS_GRAPHICS_TARGET_NOT_IN_TOPOLOGY = HRESULT($C01E0340);
  // The specified target is not part of the specified VidPN's topology.
  STATUS_GRAPHICS_NO_DISPLAY_MODE_MANAGEMENT_SUPPORT = HRESULT($C01E0341);
  // Failed to acquire the display mode management interface.
  STATUS_GRAPHICS_VIDPN_SOURCE_IN_USE = HRESULT($C01E0342);
  // The specified VidPN source is already owned by a DMM client and cannot be used until that client releases it.
  STATUS_GRAPHICS_CANT_ACCESS_ACTIVE_VIDPN = HRESULT($C01E0343);
  // The specified VidPN is active and cannot be accessed.
  STATUS_GRAPHICS_INVALID_PATH_IMPORTANCE_ORDINAL = HRESULT($C01E0344);
  // The specified VidPN's present path importance ordinal is invalid.
  STATUS_GRAPHICS_INVALID_PATH_CONTENT_GEOMETRY_TRANSFORMATION = HRESULT($C01E0345);
  // The specified VidPN's present path content geometry transformation is invalid.
  STATUS_GRAPHICS_PATH_CONTENT_GEOMETRY_TRANSFORMATION_NOT_SUPPORTED =
    HRESULT($C01E0346);
  // The specified content geometry transformation is not supported on the respective VidPN present path.
  STATUS_GRAPHICS_INVALID_GAMMA_RAMP = HRESULT($C01E0347);
  // The specified gamma ramp is invalid.
  STATUS_GRAPHICS_GAMMA_RAMP_NOT_SUPPORTED = HRESULT($C01E0348);
  // The specified gamma ramp is not supported on the respective VidPN present path.
  STATUS_GRAPHICS_MULTISAMPLING_NOT_SUPPORTED = HRESULT($C01E0349);
  // Multisampling is not supported on the respective VidPN present path.
  STATUS_GRAPHICS_MODE_NOT_IN_MODESET = HRESULT($C01E034A);
  // The specified mode is not in the specified mode set.
  STATUS_GRAPHICS_INVALID_VIDPN_TOPOLOGY_RECOMMENDATION_REASON = HRESULT($C01E034D);
  // The specified VidPN topology recommendation reason is invalid.
  STATUS_GRAPHICS_INVALID_PATH_CONTENT_TYPE = HRESULT($C01E034E);
  // The specified VidPN present path content type is invalid.
  STATUS_GRAPHICS_INVALID_COPYPROTECTION_TYPE = HRESULT($C01E034F);
  // The specified VidPN present path copy protection type is invalid.
  STATUS_GRAPHICS_UNASSIGNED_MODESET_ALREADY_EXISTS = HRESULT($C01E0350);
  // Only one unassigned mode set can exist at any one time for a particular VidPN source or target.
  STATUS_GRAPHICS_INVALID_SCANLINE_ORDERING = HRESULT($C01E0352);
  // The specified scan line ordering type is invalid.
  STATUS_GRAPHICS_TOPOLOGY_CHANGES_NOT_ALLOWED = HRESULT($C01E0353);
  // The topology changes are not allowed for the specified VidPN.
  STATUS_GRAPHICS_NO_AVAILABLE_IMPORTANCE_ORDINALS = HRESULT($C01E0354);
  // All available importance ordinals are being used in the specified topology.
  STATUS_GRAPHICS_INCOMPATIBLE_PRIVATE_FORMAT = HRESULT($C01E0355);
  // The specified primary surface has a different private-format attribute than the current primary surface.
  STATUS_GRAPHICS_INVALID_MODE_PRUNING_ALGORITHM = HRESULT($C01E0356);
  // The specified mode-pruning algorithm is invalid.
  STATUS_GRAPHICS_INVALID_MONITOR_CAPABILITY_ORIGIN = HRESULT($C01E0357);
  // The specified monitor-capability origin is invalid.
  STATUS_GRAPHICS_INVALID_MONITOR_FREQUENCYRANGE_CONSTRAINT = HRESULT($C01E0358);
  // The specified monitor-frequency range constraint is invalid.
  STATUS_GRAPHICS_MAX_NUM_PATHS_REACHED = HRESULT($C01E0359);
  // The maximum supported number of present paths has been reached.
  STATUS_GRAPHICS_CANCEL_VIDPN_TOPOLOGY_AUGMENTATION = HRESULT($C01E035A);
  // The miniport requested that augmentation be canceled for the specified source of the specified VidPN's topology.
  STATUS_GRAPHICS_INVALID_CLIENT_TYPE = HRESULT($C01E035B);
  // The specified client type was not recognized.
  STATUS_GRAPHICS_CLIENTVIDPN_NOT_SET = HRESULT($C01E035C);
  // The client VidPN is not set on this adapter (for example, no user mode-initiated mode changes have taken place on this adapter).
  STATUS_GRAPHICS_SPECIFIED_CHILD_ALREADY_CONNECTED = HRESULT($C01E0400);
  // The specified display adapter child device already has an external device connected to it.
  STATUS_GRAPHICS_CHILD_DESCRIPTOR_NOT_SUPPORTED = HRESULT($C01E0401);
  // The display adapter child device does not support reporting a descriptor.
  STATUS_GRAPHICS_NOT_A_LINKED_ADAPTER = HRESULT($C01E0430);
  // The display adapter is not linked to any other adapters.
  STATUS_GRAPHICS_LEADLINK_NOT_ENUMERATED = HRESULT($C01E0431);
  // The lead adapter in a linked configuration was not enumerated yet.
  STATUS_GRAPHICS_CHAINLINKS_NOT_ENUMERATED = HRESULT($C01E0432);
  // Some chain adapters in a linked configuration have not yet been enumerated.
  STATUS_GRAPHICS_ADAPTER_CHAIN_NOT_READY = HRESULT($C01E0433);
  // The chain of linked adapters is not ready to start because of an unknown failure.
  STATUS_GRAPHICS_CHAINLINKS_NOT_STARTED = HRESULT($C01E0434);
  // An attempt was made to start a lead link display adapter when the chain links had not yet started.
  STATUS_GRAPHICS_CHAINLINKS_NOT_POWERED_ON = HRESULT($C01E0435);
  // An attempt was made to turn on a lead link display adapter when the chain links were turned off.
  STATUS_GRAPHICS_INCONSISTENT_DEVICE_LINK_STATE = HRESULT($C01E0436);
  // The adapter link was found in an inconsistent state. Not all adapters are in an expected PNP/power state.
  STATUS_GRAPHICS_NOT_POST_DEVICE_DRIVER = HRESULT($C01E0438);
  // The driver trying to start is not the same as the driver for the posted display adapter.
  STATUS_GRAPHICS_ADAPTER_ACCESS_NOT_EXCLUDED = HRESULT($C01E043B);
  // An operation is being attempted that requires the display adapter to be in a quiescent state.
  STATUS_GRAPHICS_OPM_NOT_SUPPORTED = HRESULT($C01E0500);
  // The driver does not support OPM.
  STATUS_GRAPHICS_COPP_NOT_SUPPORTED = HRESULT($C01E0501);
  // The driver does not support COPP.
  STATUS_GRAPHICS_UAB_NOT_SUPPORTED = HRESULT($C01E0502);
  // The driver does not support UAB.
  STATUS_GRAPHICS_OPM_INVALID_ENCRYPTED_PARAMETERS = HRESULT($C01E0503);
  // The specified encrypted parameters are invalid.
  STATUS_GRAPHICS_OPM_PARAMETER_ARRAY_TOO_SMALL = HRESULT($C01E0504);
  // An array passed to a function cannot hold all of the data that the function wants to put in it.
  STATUS_GRAPHICS_OPM_NO_PROTECTED_OUTPUTS_EXIST = HRESULT($C01E0505);
  // The GDI display device passed to this function does not have any active protected outputs.
  STATUS_GRAPHICS_PVP_NO_DISPLAY_DEVICE_CORRESPONDS_TO_NAME = HRESULT($C01E0506);
  // The PVP cannot find an actual GDI display device that corresponds to the passed-in GDI display device name.
  STATUS_GRAPHICS_PVP_DISPLAY_DEVICE_NOT_ATTACHED_TO_DESKTOP = HRESULT($C01E0507);
  // This function failed because the GDI display device passed to it was not attached to the Windows desktop.
  STATUS_GRAPHICS_PVP_MIRRORING_DEVICES_NOT_SUPPORTED = HRESULT($C01E0508);
  // The PVP does not support mirroring display devices because they do not have any protected outputs.
  STATUS_GRAPHICS_OPM_INVALID_POINTER = HRESULT($C01E050A);
  // The function failed because an invalid pointer parameter was passed to it. A pointer parameter is invalid if it is null, is not correctly aligned, or it points to an invalid address or a kernel mode address.
  STATUS_GRAPHICS_OPM_INTERNAL_ERROR = HRESULT($C01E050B);
  // An internal error caused an operation to fail.
  STATUS_GRAPHICS_OPM_INVALID_HANDLE = HRESULT($C01E050C);
  // The function failed because the caller passed in an invalid OPM user-mode handle.
  STATUS_GRAPHICS_PVP_NO_MONITORS_CORRESPOND_TO_DISPLAY_DEVICE = HRESULT($C01E050D);
  // This function failed because the GDI device passed to it did not have any monitors associated with it.
  STATUS_GRAPHICS_PVP_INVALID_CERTIFICATE_LENGTH = HRESULT($C01E050E);
  // A certificate could not be returned because the certificate buffer passed to the function was too small.
  STATUS_GRAPHICS_OPM_SPANNING_MODE_ENABLED = HRESULT($C01E050F);
  // DxgkDdiOpmCreateProtectedOutput() could not create a protected output because the video present yarget is in spanning mode.
  STATUS_GRAPHICS_OPM_THEATER_MODE_ENABLED = HRESULT($C01E0510);
  // DxgkDdiOpmCreateProtectedOutput() could not create a protected output because the video present target is in theater mode.
  STATUS_GRAPHICS_PVP_HFS_FAILED = HRESULT($C01E0511);
  // The function call failed because the display adapter's hardware functionality scan (HFS) failed to validate the graphics hardware.
  STATUS_GRAPHICS_OPM_INVALID_SRM = HRESULT($C01E0512);
  // The HDCP SRM passed to this function did not comply with section 5 of the HDCP 1.1 specification.
  STATUS_GRAPHICS_OPM_OUTPUT_DOES_NOT_SUPPORT_HDCP = HRESULT($C01E0513);
  // The protected output cannot enable the HDCP system because it does not support it.
  STATUS_GRAPHICS_OPM_OUTPUT_DOES_NOT_SUPPORT_ACP = HRESULT($C01E0514);
  // The protected output cannot enable analog copy protection because it does not support it.
  STATUS_GRAPHICS_OPM_OUTPUT_DOES_NOT_SUPPORT_CGMSA = HRESULT($C01E0515);
  // The protected output cannot enable the CGMS-A protection technology because it does not support it.
  STATUS_GRAPHICS_OPM_HDCP_SRM_NEVER_SET = HRESULT($C01E0516);
  // DxgkDdiOPMGetInformation() cannot return the version of the SRM being used because the application never successfully passed an SRM to the protected output.
  STATUS_GRAPHICS_OPM_RESOLUTION_TOO_HIGH = HRESULT($C01E0517);
  // DxgkDdiOPMConfigureProtectedOutput() cannot enable the specified output protection technology because the output's screen resolution is too high.
  STATUS_GRAPHICS_OPM_ALL_HDCP_HARDWARE_ALREADY_IN_USE = HRESULT($C01E0518);
  // DxgkDdiOPMConfigureProtectedOutput() cannot enable HDCP because other physical outputs are using the display adapter's HDCP hardware.
  STATUS_GRAPHICS_OPM_PROTECTED_OUTPUT_NO_LONGER_EXISTS = HRESULT($C01E051A);
  // The operating system asynchronously destroyed this OPM-protected output because the operating system state changed. This error typically occurs because the monitor PDO associated with this protected output was removed or stopped, the protected output's session became a nonconsole session, or the protected output's desktop became inactive.
  STATUS_GRAPHICS_OPM_SESSION_TYPE_CHANGE_IN_PROGRESS = HRESULT($C01E051B);
  // OPM functions cannot be called when a session is changing its type. Three types of sessions currently exist: console, disconnected, and remote (RDP or ICA).
  STATUS_GRAPHICS_OPM_PROTECTED_OUTPUT_DOES_NOT_HAVE_COPP_SEMANTICS = HRESULT($C01E051C);
  // The DxgkDdiOPMGetCOPPCompatibleInformation, DxgkDdiOPMGetInformation, or DxgkDdiOPMConfigureProtectedOutput function failed. This error is returned only if a protected output has OPM semantics. DxgkDdiOPMGetCOPPCompatibleInformation always returns this error if a protected output has OPM semantics. DxgkDdiOPMGetInformation returns this error code if the caller requested COPP-specific information.  DxgkDdiOPMConfigureProtectedOutput returns this error when the caller tries to use a COPP-specific command.
  STATUS_GRAPHICS_OPM_INVALID_INFORMATION_REQUEST = HRESULT($C01E051D);
  // The DxgkDdiOPMGetInformation and DxgkDdiOPMGetCOPPCompatibleInformation functions return this error code if the passed-in sequence number is not the expected sequence number or the passed-in OMAC value is invalid.
  STATUS_GRAPHICS_OPM_DRIVER_INTERNAL_ERROR = HRESULT($C01E051E);
  // The function failed because an unexpected error occurred inside a display driver.
  STATUS_GRAPHICS_OPM_PROTECTED_OUTPUT_DOES_NOT_HAVE_OPM_SEMANTICS = HRESULT($C01E051F);
  // The DxgkDdiOPMGetCOPPCompatibleInformation, DxgkDdiOPMGetInformation, or DxgkDdiOPMConfigureProtectedOutput function failed. This error is returned only if a protected output has COPP semantics. DxgkDdiOPMGetCOPPCompatibleInformation returns this error code if the caller requested OPM-specific information.  DxgkDdiOPMGetInformation always returns this error if a protected output has COPP semantics.  DxgkDdiOPMConfigureProtectedOutput returns this error when the caller tries to use an OPM-specific command.
  STATUS_GRAPHICS_OPM_SIGNALING_NOT_SUPPORTED = HRESULT($C01E0520);
  // The DxgkDdiOPMGetCOPPCompatibleInformation and DxgkDdiOPMConfigureProtectedOutput functions return this error if the display driver does not support the DXGKMDT_OPM_GET_ACP_AND_CGMSA_SIGNALING and DXGKMDT_OPM_SET_ACP_AND_CGMSA_SIGNALING GUIDs.
  STATUS_GRAPHICS_OPM_INVALID_CONFIGURATION_REQUEST = HRESULT($C01E0521);
  // The DxgkDdiOPMConfigureProtectedOutput function returns this error code if the passed-in sequence number is not the expected sequence number or the passed-in OMAC value is invalid.
  STATUS_GRAPHICS_I2C_NOT_SUPPORTED = HRESULT($C01E0580);
  // The monitor connected to the specified video output does not have an I2C bus.
  STATUS_GRAPHICS_I2C_DEVICE_DOES_NOT_EXIST = HRESULT($C01E0581);
  // No device on the I2C bus has the specified address.
  STATUS_GRAPHICS_I2C_ERROR_TRANSMITTING_DATA = HRESULT($C01E0582);
  // An error occurred while transmitting data to the device on the I2C bus.
  STATUS_GRAPHICS_I2C_ERROR_RECEIVING_DATA = HRESULT($C01E0583);
  // An error occurred while receiving data from the device on the I2C bus.
  STATUS_GRAPHICS_DDCCI_VCP_NOT_SUPPORTED = HRESULT($C01E0584);
  // The monitor does not support the specified VCP code.
  STATUS_GRAPHICS_DDCCI_INVALID_DATA = HRESULT($C01E0585);
  // The data received from the monitor is invalid.
  STATUS_GRAPHICS_DDCCI_MONITOR_RETURNED_INVALID_TIMING_STATUS_BYTE = HRESULT($C01E0586);
  // A function call failed because a monitor returned an invalid timing status byte when the operating system used the DDC/CI get timing report and timing message command to get a timing report from a monitor.
  STATUS_GRAPHICS_DDCCI_INVALID_CAPABILITIES_STRING = HRESULT($C01E0587);
  // A monitor returned a DDC/CI capabilities string that did not comply with the ACCESS.bus 3.0, DDC/CI 1.1, or MCCS 2 Revision 1 specification.
  STATUS_GRAPHICS_MCA_INTERNAL_ERROR = HRESULT($C01E0588);
  // An internal error caused an operation to fail.
  STATUS_GRAPHICS_DDCCI_INVALID_MESSAGE_COMMAND = HRESULT($C01E0589);
  // An operation failed because a DDC/CI message had an invalid value in its command field.
  STATUS_GRAPHICS_DDCCI_INVALID_MESSAGE_LENGTH = HRESULT($C01E058A);
  // This error occurred because a DDC/CI message had an invalid value in its length field.
  STATUS_GRAPHICS_DDCCI_INVALID_MESSAGE_CHECKSUM = HRESULT($C01E058B);
  // This error occurred because the value in a DDC/CI message's checksum field did not match the message's computed checksum value. This error implies that the data was corrupted while it was being transmitted from a monitor to a computer.
  STATUS_GRAPHICS_INVALID_PHYSICAL_MONITOR_HANDLE = HRESULT($C01E058C);
  // This function failed because an invalid monitor handle was passed to it.
  STATUS_GRAPHICS_MONITOR_NO_LONGER_EXISTS = HRESULT($C01E058D);
  // The operating system asynchronously destroyed the monitor that corresponds to this handle because the operating system's state changed. This error typically occurs because the monitor PDO associated with this handle was removed or stopped, or a display mode change occurred. A display mode change occurs when Windows sends a WM_DISPLAYCHANGE message to applications.
  STATUS_GRAPHICS_ONLY_CONSOLE_SESSION_SUPPORTED = HRESULT($C01E05E0);
  // This function can be used only if a program is running in the local console session. It cannot be used if a program is running on a remote desktop session or on a terminal server session.
  STATUS_GRAPHICS_NO_DISPLAY_DEVICE_CORRESPONDS_TO_NAME = HRESULT($C01E05E1);
  // This function cannot find an actual GDI display device that corresponds to the specified GDI display device name.
  STATUS_GRAPHICS_DISPLAY_DEVICE_NOT_ATTACHED_TO_DESKTOP = HRESULT($C01E05E2);
  // The function failed because the specified GDI display device was not attached to the Windows desktop.
  STATUS_GRAPHICS_MIRRORING_DEVICES_NOT_SUPPORTED = HRESULT($C01E05E3);
  // This function does not support GDI mirroring display devices because GDI mirroring display devices do not have any physical monitors associated with them.
  STATUS_GRAPHICS_INVALID_POINTER = HRESULT($C01E05E4);
  // The function failed because an invalid pointer parameter was passed to it. A pointer parameter is invalid if it is null, is not correctly aligned, or points to an invalid address or to a kernel mode address.
  STATUS_GRAPHICS_NO_MONITORS_CORRESPOND_TO_DISPLAY_DEVICE = HRESULT($C01E05E5);
  // This function failed because the GDI device passed to it did not have a monitor associated with it.
  STATUS_GRAPHICS_PARAMETER_ARRAY_TOO_SMALL = HRESULT($C01E05E6);
  // An array passed to the function cannot hold all of the data that the function must copy into the array.
  STATUS_GRAPHICS_INTERNAL_ERROR = HRESULT($C01E05E7);
  // An internal error caused an operation to fail.
  STATUS_GRAPHICS_SESSION_TYPE_CHANGE_IN_PROGRESS = HRESULT($C01E05E8);
  // The function failed because the current session is changing its type. This function cannot be called when the current session is changing its type. Three types of sessions currently exist: console, disconnected, and remote (RDP or ICA).
  STATUS_FVE_LOCKED_VOLUME = HRESULT($C0210000);
  // The volume must be unlocked before it can be used.
  STATUS_FVE_NOT_ENCRYPTED = HRESULT($C0210001);
  // The volume is fully decrypted and no key is available.
  STATUS_FVE_BAD_INFORMATION = HRESULT($C0210002);
  // The control block for the encrypted volume is not valid.
  STATUS_FVE_TOO_SMALL = HRESULT($C0210003);
  // Not enough free space remains on the volume to allow encryption.
  STATUS_FVE_FAILED_WRONG_FS = HRESULT($C0210004);
  // The partition cannot be encrypted because the file system is not supported.
  STATUS_FVE_FAILED_BAD_FS = HRESULT($C0210005);
  // The file system is inconsistent. Run the Check Disk utility.
  STATUS_FVE_FS_NOT_EXTENDED = HRESULT($C0210006);
  // The file system does not extend to the end of the volume.
  STATUS_FVE_FS_MOUNTED = HRESULT($C0210007);
  // This operation cannot be performed while a file system is mounted on the volume.
  STATUS_FVE_NO_LICENSE = HRESULT($C0210008);
  // BitLocker Drive Encryption is not included with this version of Windows.
  STATUS_FVE_ACTION_NOT_ALLOWED = HRESULT($C0210009);
  // The requested action was denied by the FVE control engine.
  STATUS_FVE_BAD_DATA         = HRESULT($C021000A); // The data supplied is malformed.
  STATUS_FVE_VOLUME_NOT_BOUND = HRESULT($C021000B);
  // The volume is not bound to the system.
  STATUS_FVE_NOT_DATA_VOLUME = HRESULT($C021000C);
  // The volume specified is not a data volume.
  STATUS_FVE_CONV_READ_ERROR = HRESULT($C021000D);
  // A read operation failed while converting the volume.
  STATUS_FVE_CONV_WRITE_ERROR = HRESULT($C021000E);
  // A write operation failed while converting the volume.
  STATUS_FVE_OVERLAPPED_UPDATE = HRESULT($C021000F);
  // The control block for the encrypted volume was updated by another thread. Try again.
  STATUS_FVE_FAILED_SECTOR_SIZE = HRESULT($C0210010);
  // The volume encryption algorithm cannot be used on this sector size.
  STATUS_FVE_FAILED_AUTHENTICATION = HRESULT($C0210011);
  // BitLocker recovery authentication failed.
  STATUS_FVE_NOT_OS_VOLUME = HRESULT($C0210012);
  // The volume specified is not the boot operating system volume.
  STATUS_FVE_KEYFILE_NOT_FOUND = HRESULT($C0210013);
  // The BitLocker startup key or recovery password could not be read from external media.
  STATUS_FVE_KEYFILE_INVALID = HRESULT($C0210014);
  // The BitLocker startup key or recovery password file is corrupt or invalid.
  STATUS_FVE_KEYFILE_NO_VMK = HRESULT($C0210015);
  // The BitLocker encryption key could not be obtained from the startup key or the recovery password.
  STATUS_FVE_TPM_DISABLED          = HRESULT($C0210016); // The TPM is disabled.
  STATUS_FVE_TPM_SRK_AUTH_NOT_ZERO = HRESULT($C0210017);
  // The authorization data for the SRK of the TPM is not zero.
  STATUS_FVE_TPM_INVALID_PCR = HRESULT($C0210018);
  // The system boot information changed or the TPM locked out access to BitLocker encryption keys until the computer is restarted.
  STATUS_FVE_TPM_NO_VMK = HRESULT($C0210019);
  // The BitLocker encryption key could not be obtained from the TPM.
  STATUS_FVE_PIN_INVALID = HRESULT($C021001A);
  // The BitLocker encryption key could not be obtained from the TPM and PIN.
  STATUS_FVE_AUTH_INVALID_APPLICATION = HRESULT($C021001B);
  // A boot application hash does not match the hash computed when BitLocker was turned on.
  STATUS_FVE_AUTH_INVALID_CONFIG = HRESULT($C021001C);
  // The Boot Configuration Data (BCD) settings are not supported or have changed because BitLocker was enabled.
  STATUS_FVE_DEBUGGER_ENABLED = HRESULT($C021001D);
  // Boot debugging is enabled. Run Windows Boot Configuration Data Store Editor (bcdedit.exe) to turn it off.
  STATUS_FVE_DRY_RUN_FAILED = HRESULT($C021001E);
  // The BitLocker encryption key could not be obtained.
  STATUS_FVE_BAD_METADATA_POINTER = HRESULT($C021001F);
  // The metadata disk region pointer is incorrect.
  STATUS_FVE_OLD_METADATA_COPY = HRESULT($C0210020);
  // The backup copy of the metadata is out of date.
  STATUS_FVE_REBOOT_REQUIRED = HRESULT($C0210021);
  // No action was taken because a system restart is required.
  STATUS_FVE_RAW_ACCESS = HRESULT($C0210022);
  // No action was taken because BitLocker Drive Encryption is in RAW access mode.
  STATUS_FVE_RAW_BLOCKED = HRESULT($C0210023);
  // BitLocker Drive Encryption cannot enter RAW access mode for this volume.
  STATUS_FVE_NO_FEATURE_LICENSE = HRESULT($C0210026);
  // This feature of BitLocker Drive Encryption is not included with this version of Windows.
  STATUS_FVE_POLICY_USER_DISABLE_RDV_NOT_ALLOWED = HRESULT($C0210027);
  // Group policy does not permit turning off BitLocker Drive Encryption on roaming data volumes.
  STATUS_FVE_CONV_RECOVERY_FAILED = HRESULT($C0210028);
  // Bitlocker Drive Encryption failed to recover from aborted conversion. This could be due to either all conversion logs being corrupted or the media being write-protected.
  STATUS_FVE_VIRTUALIZED_SPACE_TOO_BIG = HRESULT($C0210029);
  // The requested virtualization size is too big.
  STATUS_FVE_VOLUME_TOO_SMALL = HRESULT($C0210030);
  // The drive is too small to be protected using BitLocker Drive Encryption.
  STATUS_FWP_CALLOUT_NOT_FOUND   = HRESULT($C0220001); // The callout does not exist.
  STATUS_FWP_CONDITION_NOT_FOUND = HRESULT($C0220002);
  // The filter condition does not exist.
  STATUS_FWP_FILTER_NOT_FOUND   = HRESULT($C0220003); // The filter does not exist.
  STATUS_FWP_LAYER_NOT_FOUND    = HRESULT($C0220004); // The layer does not exist.
  STATUS_FWP_PROVIDER_NOT_FOUND = HRESULT($C0220005); // The provider does not exist.
  STATUS_FWP_PROVIDER_CONTEXT_NOT_FOUND = HRESULT($C0220006);
  // The provider context does not exist.
  STATUS_FWP_SUBLAYER_NOT_FOUND = HRESULT($C0220007); // The sublayer does not exist.
  STATUS_FWP_NOT_FOUND          = HRESULT($C0220008); // The object does not exist.
  STATUS_FWP_ALREADY_EXISTS     = HRESULT($C0220009);
  // An object with that GUID or LUID already exists.
  STATUS_FWP_IN_USE = HRESULT($C022000A);
  // The object is referenced by other objects and cannot be deleted.
  STATUS_FWP_DYNAMIC_SESSION_IN_PROGRESS = HRESULT($C022000B);
  // The call is not allowed from within a dynamic session.
  STATUS_FWP_WRONG_SESSION = HRESULT($C022000C);
  // The call was made from the wrong session and cannot be completed.
  STATUS_FWP_NO_TXN_IN_PROGRESS = HRESULT($C022000D);
  // The call must be made from within an explicit transaction.
  STATUS_FWP_TXN_IN_PROGRESS = HRESULT($C022000E);
  // The call is not allowed from within an explicit transaction.
  STATUS_FWP_TXN_ABORTED = HRESULT($C022000F);
  // The explicit transaction has been forcibly canceled.
  STATUS_FWP_SESSION_ABORTED  = HRESULT($C0220010); // The session has been canceled.
  STATUS_FWP_INCOMPATIBLE_TXN = HRESULT($C0220011);
  // The call is not allowed from within a read-only transaction.
  STATUS_FWP_TIMEOUT = HRESULT($C0220012);
  // The call timed out while waiting to acquire the transaction lock.
  STATUS_FWP_NET_EVENTS_DISABLED = HRESULT($C0220013);
  // The collection of network diagnostic events is disabled.
  STATUS_FWP_INCOMPATIBLE_LAYER = HRESULT($C0220014);
  // The operation is not supported by the specified layer.
  STATUS_FWP_KM_CLIENTS_ONLY = HRESULT($C0220015);
  // The call is allowed for kernel-mode callers only.
  STATUS_FWP_LIFETIME_MISMATCH = HRESULT($C0220016);
  // The call tried to associate two objects with incompatible lifetimes.
  STATUS_FWP_BUILTIN_OBJECT = HRESULT($C0220017);
  // The object is built-in and cannot be deleted.
  STATUS_FWP_TOO_MANY_BOOTTIME_FILTERS = HRESULT($C0220018);
  // The maximum number of boot-time filters has been reached.
  STATUS_FWP_TOO_MANY_CALLOUTS = HRESULT($C0220018);
  // The maximum number of callouts has been reached.
  STATUS_FWP_NOTIFICATION_DROPPED = HRESULT($C0220019);
  // A notification could not be delivered because a message queue has reached maximum capacity.
  STATUS_FWP_TRAFFIC_MISMATCH = HRESULT($C022001A);
  // The traffic parameters do not match those for the security association context.
  STATUS_FWP_INCOMPATIBLE_SA_STATE = HRESULT($C022001B);
  // The call is not allowed for the current security association state.
  STATUS_FWP_NULL_POINTER       = HRESULT($C022001C); // A required pointer is null.
  STATUS_FWP_INVALID_ENUMERATOR = HRESULT($C022001D); // An enumerator is not valid.
  STATUS_FWP_INVALID_FLAGS      = HRESULT($C022001E);
  // The flags field contains an invalid value.
  STATUS_FWP_INVALID_NET_MASK  = HRESULT($C022001F); // A network mask is not valid.
  STATUS_FWP_INVALID_RANGE     = HRESULT($C0220020); // An FWP_RANGE is not valid.
  STATUS_FWP_INVALID_INTERVAL  = HRESULT($C0220021); // The time interval is not valid.
  STATUS_FWP_ZERO_LENGTH_ARRAY = HRESULT($C0220022);
  // An array that must contain at least one element has a zero length.
  STATUS_FWP_NULL_DISPLAY_NAME = HRESULT($C0220023);
  // The displayData.name field cannot be null.
  STATUS_FWP_INVALID_ACTION_TYPE = HRESULT($C0220024);
  // The action type is not one of the allowed action types for a filter.
  STATUS_FWP_INVALID_WEIGHT = HRESULT($C0220025); // The filter weight is not valid.
  STATUS_FWP_MATCH_TYPE_MISMATCH = HRESULT($C0220026);
  // A filter condition contains a match type that is not compatible with the operands.
  STATUS_FWP_TYPE_MISMATCH = HRESULT($C0220027);
  // An FWP_VALUE or FWPM_CONDITION_VALUE is of the wrong type.
  STATUS_FWP_OUT_OF_BOUNDS = HRESULT($C0220028);
  // An integer value is outside the allowed range.
  STATUS_FWP_RESERVED            = HRESULT($C0220029); // A reserved field is nonzero.
  STATUS_FWP_DUPLICATE_CONDITION = HRESULT($C022002A);
  // A filter cannot contain multiple conditions operating on a single field.
  STATUS_FWP_DUPLICATE_KEYMOD = HRESULT($C022002B);
  // A policy cannot contain the same keying module more than once.
  STATUS_FWP_ACTION_INCOMPATIBLE_WITH_LAYER = HRESULT($C022002C);
  // The action type is not compatible with the layer.
  STATUS_FWP_ACTION_INCOMPATIBLE_WITH_SUBLAYER = HRESULT($C022002D);
  // The action type is not compatible with the sublayer.
  STATUS_FWP_CONTEXT_INCOMPATIBLE_WITH_LAYER = HRESULT($C022002E);
  // The raw context or the provider context is not compatible with the layer.
  STATUS_FWP_CONTEXT_INCOMPATIBLE_WITH_CALLOUT = HRESULT($C022002F);
  // The raw context or the provider context is not compatible with the callout.
  STATUS_FWP_INCOMPATIBLE_AUTH_METHOD = HRESULT($C0220030);
  // The authentication method is not compatible with the policy type.
  STATUS_FWP_INCOMPATIBLE_DH_GROUP = HRESULT($C0220031);
  // The Diffie-Hellman group is not compatible with the policy type.
  STATUS_FWP_EM_NOT_SUPPORTED = HRESULT($C0220032);
  // An IKE policy cannot contain an Extended Mode policy.
  STATUS_FWP_NEVER_MATCH = HRESULT($C0220033);
  // The enumeration template or subscription will never match any objects.
  STATUS_FWP_PROVIDER_CONTEXT_MISMATCH = HRESULT($C0220034);
  // The provider context is of the wrong type.
  STATUS_FWP_INVALID_PARAMETER  = HRESULT($C0220035); // The parameter is incorrect.
  STATUS_FWP_TOO_MANY_SUBLAYERS = HRESULT($C0220036);
  // The maximum number of sublayers has been reached.
  STATUS_FWP_CALLOUT_NOTIFICATION_FAILED = HRESULT($C0220037);
  // The notification function for a callout returned an error.
  STATUS_FWP_INCOMPATIBLE_AUTH_CONFIG = HRESULT($C0220038);
  // The IPsec authentication configuration is not compatible with the authentication type.
  STATUS_FWP_INCOMPATIBLE_CIPHER_CONFIG = HRESULT($C0220039);
  // The IPsec cipher configuration is not compatible with the cipher type.
  STATUS_FWP_DUPLICATE_AUTH_METHOD = HRESULT($C022003C);
  // A policy cannot contain the same auth method more than once.
  STATUS_FWP_TCPIP_NOT_READY = HRESULT($C0220100); // The TCP/IP stack is not ready.
  STATUS_FWP_INJECT_HANDLE_CLOSING = HRESULT($C0220101);
  // The injection handle is being closed by another thread.
  STATUS_FWP_INJECT_HANDLE_STALE = HRESULT($C0220102); // The injection handle is stale.
  STATUS_FWP_CANNOT_PEND         = HRESULT($C0220103); // The classify cannot be pended.
  STATUS_NDIS_CLOSING            = HRESULT($C0230002);
  // The binding to the network interface is being closed.
  STATUS_NDIS_BAD_VERSION = HRESULT($C0230004); // An invalid version was specified.
  STATUS_NDIS_BAD_CHARACTERISTICS = HRESULT($C0230005);
  // An invalid characteristics table was used.
  STATUS_NDIS_ADAPTER_NOT_FOUND = HRESULT($C0230006);
  // Failed to find the network interface or the network interface is not ready.
  STATUS_NDIS_OPEN_FAILED = HRESULT($C0230007); // Failed to open the network interface.
  STATUS_NDIS_DEVICE_FAILED = HRESULT($C0230008);
  // The network interface has encountered an internal unrecoverable failure.
  STATUS_NDIS_MULTICAST_FULL = HRESULT($C0230009);
  // The multicast list on the network interface is full.
  STATUS_NDIS_MULTICAST_EXISTS = HRESULT($C023000A);
  // An attempt was made to add a duplicate multicast address to the list.
  STATUS_NDIS_MULTICAST_NOT_FOUND = HRESULT($C023000B);
  // At attempt was made to remove a multicast address that was never added.
  STATUS_NDIS_REQUEST_ABORTED = HRESULT($C023000C);
  // The network interface aborted the request.
  STATUS_NDIS_RESET_IN_PROGRESS = HRESULT($C023000D);
  // The network interface cannot process the request because it is being reset.
  STATUS_NDIS_INVALID_PACKET = HRESULT($C023000F);
  // An attempt was made to send an invalid packet on a network interface.
  STATUS_NDIS_INVALID_DEVICE_REQUEST = HRESULT($C0230010);
  // The specified request is not a valid operation for the target device.
  STATUS_NDIS_ADAPTER_NOT_READY = HRESULT($C0230011);
  // The network interface is not ready to complete this operation.
  STATUS_NDIS_INVALID_LENGTH = HRESULT($C0230014);
  // The length of the buffer submitted for this operation is not valid.
  STATUS_NDIS_INVALID_DATA = HRESULT($C0230015);
  // The data used for this operation is not valid.
  STATUS_NDIS_BUFFER_TOO_SHORT = HRESULT($C0230016);
  // The length of the submitted buffer for this operation is too small.
  STATUS_NDIS_INVALID_OID = HRESULT($C0230017);
  // The network interface does not support this object identifier.
  STATUS_NDIS_ADAPTER_REMOVED = HRESULT($C0230018);
  // The network interface has been removed.
  STATUS_NDIS_UNSUPPORTED_MEDIA = HRESULT($C0230019);
  // The network interface does not support this media type.
  STATUS_NDIS_GROUP_ADDRESS_IN_USE = HRESULT($C023001A);
  // An attempt was made to remove a token ring group address that is in use by other components.
  STATUS_NDIS_FILE_NOT_FOUND = HRESULT($C023001B);
  // An attempt was made to map a file that cannot be found.
  STATUS_NDIS_ERROR_READING_FILE = HRESULT($C023001C);
  // An error occurred while NDIS tried to map the file.
  STATUS_NDIS_ALREADY_MAPPED = HRESULT($C023001D);
  // An attempt was made to map a file that is already mapped.
  STATUS_NDIS_RESOURCE_CONFLICT = HRESULT($C023001E);
  // An attempt to allocate a hardware resource failed because the resource is used by another component.
  STATUS_NDIS_MEDIA_DISCONNECTED = HRESULT($C023001F);
  // The I/O operation failed because the network media is disconnected or the wireless access point is out of range.
  STATUS_NDIS_INVALID_ADDRESS = HRESULT($C0230022);
  // The network address used in the request is invalid.
  STATUS_NDIS_PAUSED = HRESULT($C023002A);
  // The offload operation on the network interface has been paused.
  STATUS_NDIS_INTERFACE_NOT_FOUND = HRESULT($C023002B);
  // The network interface was not found.
  STATUS_NDIS_UNSUPPORTED_REVISION = HRESULT($C023002C);
  // The revision number specified in the structure is not supported.
  STATUS_NDIS_INVALID_PORT = HRESULT($C023002D);
  // The specified port does not exist on this network interface.
  STATUS_NDIS_INVALID_PORT_STATE = HRESULT($C023002E);
  // The current state of the specified port on this network interface does not support the requested operation.
  STATUS_NDIS_LOW_POWER_STATE = HRESULT($C023002F);
  // The miniport adapter is in a lower power state.
  STATUS_NDIS_NOT_SUPPORTED = HRESULT($C02300BB);
  // The network interface does not support this request.
  STATUS_NDIS_OFFLOAD_POLICY = HRESULT($C023100F);
  // The TCP connection is not offloadable because of a local policy setting.
  STATUS_NDIS_OFFLOAD_CONNECTION_REJECTED = HRESULT($C0231012);
  // The TCP connection is not offloadable by the Chimney offload target.
  STATUS_NDIS_OFFLOAD_PATH_REJECTED = HRESULT($C0231013);
  // The IP Path object is not in an offloadable state.
  STATUS_NDIS_DOT11_AUTO_CONFIG_ENABLED = HRESULT($C0232000);
  // The wireless LAN interface is in auto-configuration mode and does not support the requested parameter change operation.
  STATUS_NDIS_DOT11_MEDIA_IN_USE = HRESULT($C0232001);
  // The wireless LAN interface is busy and cannot perform the requested operation.
  STATUS_NDIS_DOT11_POWER_STATE_INVALID = HRESULT($C0232002);
  // The wireless LAN interface is power down and does not support the requested operation.
  STATUS_NDIS_PM_WOL_PATTERN_LIST_FULL = HRESULT($C0232003);
  // The list of wake on LAN patterns is full.
  STATUS_NDIS_PM_PROTOCOL_OFFLOAD_LIST_FULL = HRESULT($C0232004);
  // The list of low power protocol offloads is full.
  STATUS_IPSEC_BAD_SPI = HRESULT($C0360001);
  // The SPI in the packet does not match a valid IPsec SA.
  STATUS_IPSEC_SA_LIFETIME_EXPIRED = HRESULT($C0360002);
  // The packet was received on an IPsec SA whose lifetime has expired.
  STATUS_IPSEC_WRONG_SA = HRESULT($C0360003);
  // The packet was received on an IPsec SA that does not match the packet characteristics.
  STATUS_IPSEC_REPLAY_CHECK_FAILED = HRESULT($C0360004);
  // The packet sequence number replay check failed.
  STATUS_IPSEC_INVALID_PACKET = HRESULT($C0360005);
  // The IPsec header and/or trailer in the packet is invalid.
  STATUS_IPSEC_INTEGRITY_CHECK_FAILED = HRESULT($C0360006);
  // The IPsec integrity check failed.
  STATUS_IPSEC_CLEAR_TEXT_DROP = HRESULT($C0360007);
  // IPsec dropped a clear text packet.
  STATUS_IPSEC_AUTH_FIREWALL_DROP = HRESULT($C0360008);
  // IPsec dropped an incoming ESP packet in authenticated firewall mode.  This drop is benign.
  STATUS_IPSEC_THROTTLE_DROP = HRESULT($C0360009);
  // IPsec dropped a packet due to DOS throttle.
  STATUS_IPSEC_DOSP_BLOCK = HRESULT($C0368000);
  // IPsec Dos Protection matched an explicit block rule.
  STATUS_IPSEC_DOSP_RECEIVED_MULTICAST = HRESULT($C0368001);
  // IPsec Dos Protection received an IPsec specific multicast packet which is not allowed.
  STATUS_IPSEC_DOSP_INVALID_PACKET = HRESULT($C0368002);
  // IPsec Dos Protection received an incorrectly formatted packet.
  STATUS_IPSEC_DOSP_STATE_LOOKUP_FAILED = HRESULT($C0368003);
  // IPsec Dos Protection failed to lookup state.
  STATUS_IPSEC_DOSP_MAX_ENTRIES = HRESULT($C0368004);
  // IPsec Dos Protection failed to create state because there are already maximum number of entries allowed by policy.
  STATUS_IPSEC_DOSP_KEYMOD_NOT_ALLOWED = HRESULT($C0368005);
  // IPsec Dos Protection received an IPsec negotiation packet for a keying module which is not allowed by policy.
  STATUS_IPSEC_DOSP_MAX_PER_IP_RATELIMIT_QUEUES = HRESULT($C0368006);
  // IPsec Dos Protection failed to create per internal IP ratelimit queue because there is already maximum number of queues allowed by policy.
  STATUS_VOLMGR_MIRROR_NOT_SUPPORTED = HRESULT($C038005B);
  // The system does not support mirrored volumes.
  STATUS_VOLMGR_RAID5_NOT_SUPPORTED = HRESULT($C038005C);
  // The system does not support RAID-5 volumes.
  STATUS_VIRTDISK_PROVIDER_NOT_FOUND = HRESULT($C03A0014);
  // A virtual disk support provider for the specified file was not found.
  STATUS_VIRTDISK_NOT_VIRTUAL_DISK = HRESULT($C03A0015);
  // The specified disk is not a virtual disk.
  STATUS_VHD_PARENT_VHD_ACCESS_DENIED = HRESULT($C03A0016);
  // The chain of virtual hard disks is inaccessible. The process has not been granted access rights to the parent virtual hard disk for the differencing disk.
  STATUS_VHD_CHILD_PARENT_SIZE_MISMATCH = HRESULT($C03A0017);
  // The chain of virtual hard disks is corrupted. There is a mismatch in the virtual sizes of the parent virtual hard disk and differencing disk.
  STATUS_VHD_DIFFERENCING_CHAIN_CYCLE_DETECTED = HRESULT($C03A0018);
  // The chain of virtual hard disks is corrupted. A differencing disk is indicated in its own parent chain.
  STATUS_VHD_DIFFERENCING_CHAIN_ERROR_IN_PARENT = HRESULT($C03A0019);
  // The chain of virtual hard disks is inaccessible. There was an error opening a virtual hard disk further up the chain.
  NTE_FAIL = HRESULT($80090020);
  // An internal error occurred.
  NTE_INVALID_HANDLE = HRESULT($80090026);
  NTE_INVALID_PARAMETER = HRESULT($80090027);
  NTE_NOT_SUPPORTED = HRESULT($80090029);
  NTE_NO_MORE_ITEMS = HRESULT($8009002A);
  SCARD_E_UNSUPPORTED_FEATURE = HRESULT($80100022);

implementation

end.
