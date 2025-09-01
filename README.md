# Intune-Pop-up-message
Intune remediation script to generate a popup message that the user can acknowledge.

This PowerShell detection script is designed for use with Microsoft Intune remediation. It checks whether a registry entry exists under HKLM:\Software\eDisclosure with the name Acknowledged and the value set to Yes. If the registry path or value is missing, or if the value does not match the expected state, the script returns a non-compliant status. If the value is present and correct, the script reports compliance. This allows administrators to confirm whether an employee has acknowledged a popup message and track compliance across managed devices.

Edit line 25, 35 and 54 with your requirements
