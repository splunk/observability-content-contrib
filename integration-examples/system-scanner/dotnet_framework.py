"""
SystemScanner: .NET Framework Detection Module

This module is designed to detect and report installed versions
of the .NET Framework on Windows systems.

It uses the Windows Registry to gather this information and is
only functional on Windows operating systems.

Note: This module relies on the winreg library, which is only
available on Windows systems. On other operating systems,
the get_dotnet_versions function will return a message
indicating that the winreg module is not available.
"""

try:
    import winreg as reg

    def get_dotnet_versions():
        try:
            net_versions = []
            path = r"SOFTWARE\Microsoft\NET Framework Setup\NDP"

            def check_versions(key):
                i = 0
                while True:
                    try:
                        subkey_name = reg.EnumKey(key, i)
                        subkey_path = f"{path}\\{subkey_name}"
                        with reg.OpenKey(reg.HKEY_LOCAL_MACHINE, subkey_path) as subkey:
                            try:
                                version, _ = reg.QueryValueEx(subkey, "Version")
                                net_versions.append((subkey_name, version))
                            except FileNotFoundError:
                                pass
                        i += 1
                    except OSError:
                        break

            with reg.OpenKey(reg.HKEY_LOCAL_MACHINE, path) as main_key:
                check_versions(main_key)

            return net_versions

        except OSError as e:
            return f"Error accessing registry: {e}"

except ImportError:

    def get_dotnet_versions():
        return "winreg module not available on this platform"


# Saving for a future iteration:

# def get_dotnet_versions():
#     try:
#         net_versions = []
#         path = r"SOFTWARE\Microsoft\NET Framework Setup\NDP"

#         def iterate_registry(key):
#             stack = [(key, 0)]
#             while stack:
#                 current_key, i = stack.pop()
#                 try:
#                     subkey_name = reg.EnumKey(current_key, i)
#                     subkey_path = f"{path}\\{subkey_name}"
#                     with reg.OpenKey(reg.HKEY_LOCAL_MACHINE, subkey_path) as subkey:
#                         try:
#                             version, _ = reg.QueryValueEx(subkey, "Version")
#                             net_versions.append((subkey_name, version))
#                         except FileNotFoundError:
#                             pass
#                     stack.append((current_key, i + 1))
#                 except OSError:
#                     break

#         with reg.OpenKey(reg.HKEY_LOCAL_MACHINE, path) as main_key:
#             iterate_registry(main_key)

#         return net_versions

#     except OSError as e:
#         return f"Error accessing registry: {e}"
