#
# Declare all required input variables
#
variable "access_key" {
  description = "Access Key to access SberCloud"
  sensitive   = true
  default = "DYOM3ILHOUSJGBUVD99A"
}

variable "secret_key" {
  description = "Secret Key to access SberCloud"
  sensitive   = true
  default = "pJ2piJ33d6zTGHYO0hSOMNQR2vSnOHV4wXW7qj8Q"
}

variable AccountName {
    type    = string
    default = "Sbc_migration"  
}

variable "iam_project_name" {
  description = "IAM project where to deploy infrastructure"
  default = "ru-moscow-1_testing"
}

#
# Заполняем параметры для сетевых настроек
#
# Параметры VPC
#
variable "VpcName" {
  default = "ter01"
}
variable "VpcCidr" {
  default = "10.10.0.0/16"
}
variable VPCCount {
    type    = number
    default = 1
}
#
# Параметры для создания подсетей, все маршрутизируемые пока
# Объявляем счетчик (количество) сетей, которые будем разворачивать, если 0 - не произойдет ничего
#
variable NetCount {
    type    = number
    default = 2                            // Количество развертываемых подсетей, можно много //
}
#
# Вводим параметры подсетей, их может быть >= количества, которое ввели выше.
#
variable NETs {
  type    = list(object({
    NetName          = string
    NetGateway       = string
    NetDns1          = string
    NetDns2          = string
    DHCPStartAddress = string
    DHCPEndAddress   = string
    NetV4            = string
  }))
  default = [
#
# Определение параметров для Сети №1
#
    {
      NetName          = "Net10-10"         // Имя сети  //
      NetGateway       = "10.10.10.10"      // Шлюз  //
      NetDns1          = "78.88.8.8"       // DNS 1  //
      NetDns2          = "8.8.8.8"         // DNS 2  //
      DHCPStartAddress = "10.10.10.51"      // Начало пула DHCP //
      DHCPEndAddress   = "10.10.10.150"     // Конец пула DHCP //
      NetV4            = "10.10.10.0/24"    // Сеть с маской  //
    },
#
# Определение параметров для Сети №2
#
    {
      NetName          = "Net10-11"         // Имя сети //
      NetGateway       = "10.10.11.10"      // Шлюз //
      NetDns1          = "78.88.8.8"       // DNS 1 //
      NetDns2          = "8.8.8.8"         // DNS 2 //
      DHCPStartAddress = "10.10.11.51"      // Начало пула DHCP //
      DHCPEndAddress   = "10.10.11.150"     // Конец пула DHCP //
      NetV4            = "10.10.11.0/24"    // Сеть с маской //
    },
#
# Определение параметров для Сети №3
#  
    {
      NetName          = "Net50-2"         // Имя сети //
      NetGateway       = "10.50.2.10"      // Шлюз //
      NetDns1          = "78.88.8.8"       // DNS 1 //
      NetDns2          = "8.8.8.8"         // DNS 2 //
      DHCPStartAddress = "10.50.2.51"      // Начало пула DHCP //
      DHCPEndAddress   = "10.50.2.150"     // Конец пула DHCP //
      NetV4            = "10.50.2.0/24"    // Сеть с маской //
    }
  ]
}
#
# Заполняем параметры для NAT
#
variable NATCount {
    type    = number
    default = 1                            
}
variable NATType {
    type    = number
    default = "1"                          // Возможные параметры - "1", "2", "3", "4", где "1" - small и далее по возрастающей //
}
#
# Заполняем параметры для ВМ, которые разворачиваем в vms.tf
#
# Объявляем счетчик (количество) ВМ, которые будем разворачивать, если 0 - не произойдет ничего
#
variable VMCount {
    type    = number
    default = 2                            // Количество развертываемых ВМ //
}
#
# Вводим параметры ВМ, их может быть >= количества, которое ввели выше.
#
variable VMs {
  type    = list(object({
    VmName         = string
    SecGroups      = string
    ImageName      = string
    FlavorName     = string
    AvailZone      = string
    AdminPass      = string
  }))
  default = [
#
# Определение параметров для ВМ №1
#
   {
      VmName         = "ter01"                    // Имя ВМ //
      SecGroups      = "default"                // Секьюрити группа //
      ImageName      = "CentOS 7.6 64bit"       // Имя темплейта //
      FlavorName     = "s6.small.1"             // Конфигурация - сколько ядер и сколько RAM //
      AvailZone      = "ru-moscow-1a"           // Зона //
      AdminPass      = "PassWord@123"               // Пароль пользователя root //
    },
#
# Определение параметров для ВМ №2
#  
    {
      VmName         = "ter02"                            // Имя ВМ //
      SecGroups      = "default"                    // Секьюрити группа //
      ImageName      = "CentOS 7.6 64bit"               // Имя темплейта //
      FlavorName     = "s6.small.1"             // Конфигурация - сколько ядер и сколько RAM //
      AvailZone      = "ru-moscow-1a"           // Зона //
      AdminPass      = "PassWord@123"               // Пароль пользователя root //
    },
#
# Определение параметров для ВМ №3
#  
    {
      VmName         = "VM2"                    // Имя ВМ //
      SecGroups      = "default"                        // Секьюрити группа //
      ImageName      = "CentOS 7.6 64bit"               // Имя темплейта //
      FlavorName     = "s6.small.1"             // Конфигурация - сколько ядер и сколько RAM //
      AvailZone      = "ru-moscow-1a"           // Зона //
      AdminPass      = "ChangeMe"               // Пароль пользователя root //
    },
#
# Определение параметров для ВМ №4
#  
    {
      VmName         = "VM3"                    // Имя ВМ //
      SecGroups      = "default"                        // Секьюрити группа //
      ImageName      = "CentOS 7.6 64bit"               // Имя темплейта //
      FlavorName     = "s6.small.1"             // Конфигурация - сколько ядер и сколько RAM //
      AvailZone      = "ru-moscow-1a"           // Зона //
      AdminPass      = "ChangeMe"               // Пароль пользователя root //
    },
#
# Определение параметров для ВМ №5
#  
    {
      VmName         = "VM4"                    // Имя ВМ //
      SecGroups      = "default"                    // Секьюрити группа //
      ImageName      = "CentOS 7.6 64bit"               // Имя темплейта //
      FlavorName     = "s6.small.1"             // Конфигурация - сколько ядер и сколько RAM //
      AvailZone      = "ru-moscow-1a"           // Зона //
      AdminPass      = "ChangeMe"               // Пароль пользователя root //
    },
#
# Определение параметров для ВМ №6
#  
    {
      VmName         = "VM5"                    // Имя ВМ //
      SecGroups      = "default"                // Секьюрити группа //
      ImageName      = "CentOS 7.6 64bit"               // Имя темплейта //
      FlavorName     = "s6.small.1"             // Конфигурация - сколько ядер и сколько RAM //
      AvailZone      = "ru-moscow-1a"           // Зона //
      AdminPass      = "ChangeMe"               // Пароль пользователя root //
    },
#
# Определение параметров для ВМ №7
#  
    {
      VmName         = "VM6"                    // Имя ВМ //
      SecGroups      = "default"                // Секьюрити группа //
      ImageName      = "CentOS 7.6 64bit"               // Имя темплейта //
      FlavorName     = "s6.small.1"             // Конфигурация - сколько ядер и сколько RAM //
      AvailZone      = "ru-moscow-1a"           // Зона //
      AdminPass      = "ChangeMe"               // Пароль пользователя root //
    },
#
# Определение параметров для ВМ №8
#  
    {
      VmName         = "VM7"                    // Имя ВМ //
      SecGroups      = "default"                // Секьюрити группа //
      ImageName      = "CentOS 7.6 64bit"               // Имя темплейта //
      FlavorName     = "s6.small.1"             // Конфигурация - сколько ядер и сколько RAM //
      AvailZone      = "ru-moscow-1a"           // Зона //
      AdminPass      = "ChangeMe"               // Пароль пользователя root //
    },
#
# Определение параметров для ВМ №9
#  
    {
      VmName         = "VM8"                    // Имя ВМ //
      SecGroups      = "default"                        // Секьюрити группа //
      ImageName      = "CentOS 7.6 64bit"               // Имя темплейта //
      FlavorName     = "s6.small.1"             // Конфигурация - сколько ядер и сколько RAM //
      AvailZone      = "ru-moscow-1a"           // Зона //
      AdminPass      = "ChangeMe"               // Пароль пользователя root //
    },
#
# Определение параметров для ВМ №10
#  
    {
      VmName         = "VM9"                    // Имя ВМ //
      SecGroups      = "default"                // Секьюрити группа //
      ImageName      = "CentOS 7.6 64bit"               // Имя темплейта //
      FlavorName     = "s6.small.1"             // Конфигурация - сколько ядер и сколько RAM //
      AvailZone      = "ru-moscow-1a"               // Зона //
      AdminPass      = "ChangeMe"               // Пароль пользователя root //
    }  
  ]
}
