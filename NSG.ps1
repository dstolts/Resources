<#  NSG Increasing performance, build all at once...
            "properties": {
                "securityRules": [
                    {
                        "name": "SSH-Rule",
                        "properties": {
                            "description": "Allow ssh",
                            "protocol": "Tcp",
                            "sourcePortRange": "*",
                            "destinationPortRange": "22",
                            "sourceAddressPrefix": "Internet",
                            "destinationAddressPrefix": "*",
                            "access": "Allow",
                            "priority": 2010,
                            "direction": "Inbound"
                        }
                    },
                    {
                        "name": "DSCLinux-HTTPS",
                        "properties": {
                            "description": "Allow DSC HTTPS to 5896",
                            "protocol": "Tcp",
                            "sourcePortRange": "*",
                            "destinationPortRange": "5896",
                            "sourceAddressPrefix": "*",
                            "destinationAddressPrefix": "*",
                            "access": "Allow",
                            "priority": 2011,
                            "direction": "Inbound"
                        }
                    },
                    {
                        "name": "Docker-5000-in",
                        "properties": {
                            "description": "Allow Docker Registry 5000 In",
                            "protocol": "Tcp",
                            "sourcePortRange": "*",
                            "destinationPortRange": "5000",
                            "sourceAddressPrefix": "*",
                            "destinationAddressPrefix": "*",
                            "access": "Allow",
                            "priority": 2022,
                            "direction": "Inbound"
                        }
                    },
                    {
                        "name": "Allow-RDP-3389",
                        "properties": {
                            "protocol": "TCP",
                            "sourcePortRange": "*",
                            "destinationPortRange": "3389",
                            "sourceAddressPrefix": "*",
                            "destinationAddressPrefix": "*",
                            "access": "Allow",
                            "priority": 2032,
                            "direction": "Inbound"
                        }
                    },
                    {
                        "name": "Allow-HTTPS",
                        "properties": {
                            "protocol": "TCP",
                            "sourcePortRange": "*",
                            "destinationPortRange": "443",
                            "sourceAddressPrefix": "*",
                            "destinationAddressPrefix": "*",
                            "access": "Allow",
                            "priority": 2042,
                            "direction": "Inbound"
                        }
                    },
                    {
                        "name": "Allow-HTTP",
                        "properties": {
                            "protocol": "TCP",
                            "sourcePortRange": "*",
                            "destinationPortRange": "80",
                            "sourceAddressPrefix": "*",
                            "destinationAddressPrefix": "*",
                            "access": "Allow",
                            "priority": 2052,
                            "direction": "Inbound"
                        }
                    }
                ]
            },
