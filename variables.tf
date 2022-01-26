# Переменные для подключения к тененту vCloud Director
#
variable vCDLogin {
    type    = string
    default = "ob"                          // Логин пользователя в тененте //
}
variable vCDPassword {
    type    = string
    default = "R56yt921"                    // Пароль пользователя в тененте //
}
variable vCDOrg {
    type    = string
    default = "SberCloud_Migration"         // Название организации //
}
variable vCDvDC {
    type    = string
    default = "SberCloud_Migration_VDC01"   // Название виртуального ЦОДа //
}
variable vCDUrl {
    type    = string
    default = "https://vcd.sbercloud.ru/api" // Ссылка на API vCloud Director //
}
#
# Заполняем параметры для сетевых настроек
#
# Параметры для создания подсетей, все маршрутизируемые пока
# Объявляем счетчик (количество) сетей, которые будем разворачивать, если 0 - не произойдет ничего
#
variable NetCount {
    type    = number
    default = 2                            // Количество развертываемых подсетей //
}
#
# Вводим имя Эджа в тененте
#
variable EdgeName {
    type    = string
    default = "SberCloud_Migration_Edge01" // Имя маршрутизатора в тененте //
}
#
# Вводим имя внешнего интерфейса в тененте
#
variable EdgeExt {
    type    = string
    default = "b2-pclu01-ext-net-01"       // Имя внешнего интерфейса в тененте //
}
#
# Вводим внешний ip адрес в тененте
#
variable EdgeIP {
    type    = string
    default = "45.89.226.1"                // Внешний IP в тененте //
}

variable ssh_user_home {
    type = string
    default = "/root"
}

locals {
    ssh_key_pub = "${file("/root/.ssh/id_rsa.pub")}"
}
#
# Вводим параметры подсетей, их может быть >= количества, которое ввели выше.
#
variable NETs {
  type    = list(object({
    NetName          = string
    NetGateway       = string
    NetNetmask       = string
    NetInterfaceType = string
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
      NetName          = "ter01"           // Имя сети //
      NetGateway       = "10.77.78.1"      // Шлюз //
      NetNetmask       = "255.255.255.0"   // Маска сети //
      NetInterfaceType = "distributed"     // Тип сети //
      NetDns1          = "78.88.8.8"       // DNS 1 //
      NetDns2          = "8.8.8.8"         // DNS 2 //
      DHCPStartAddress = "10.77.78.9"      // Начальный адрес DHCP //
      DHCPEndAddress   = "10.77.78.100"     // Конечный адрес DHCP //
      NetV4            = "10.77.78.0/24"    // Сеть с маской //
    },
#
# Определение параметров для Сети №2
#  
    {
      NetName          = "ter02"           // Имя сети //
      NetGateway       = "10.77.79.10"      // Шлюз //
      NetNetmask       = "255.255.255.0"   // Маска сети //
      NetInterfaceType = "distributed"     // Тип сети //
      NetDns1          = "78.88.8.8"       // DNS 1 //
      NetDns2          = "8.8.8.8"         // DNS 2 //
      DHCPStartAddress = "10.77.79.51"      // Начальный адрес DHCP //
      DHCPEndAddress   = "10.77.79.100"     // Конечный адрес DHCP //
      NetV4            = "10.77.79.0/24"    // Сеть с маской //
    }
  ]
}
#
# Заполняем параметры для ВМ, которые разворачиваем в vms.tf
#
# Объявляем счетчик (количество) ВМ, которые будем разворачивать, если 0 - не произойдет ничего
#
variable VMCount {
    type    = number
    default = 3                        // Количество развертываемых ВМ //
}
#
# Вводим параметры ВМ, их может быть >= количества, которое ввели выше.
#
variable VMs {
  type    = list(object({
    VmName         = string
    StorageProfile = string
    CatalogName    = string
    TemplateName   = string
    cpu            = number
    cores          = number
    ram            = number
  }))

   default = [
#
# Определение параметров для ВМ №1
#
   {
      VmName         = "Nomad"             // Имя ВМ и vAPP //
      StorageProfile = "Silver"          // Имя Storage Policy //
      CatalogName    = "01 Linux" // Имя каталога, где хранится темплейт //
      TemplateName   = "Ubuntu 20.04" // Имя темплейта //
      cpu            = 2                 // Количество ядер //
      cores          = 2
      ram            = 8192              // Размер ОЗУ //
    },
#
# Определение параметров для ВМ №2
#  
    {
      VmName         = "ter02"             // Имя ВМ и vAPP //
      StorageProfile = "Silver"          // Имя Storage Policy //
      CatalogName    = "02 Linux" // Имя каталога, где хранится темплейт //
      TemplateName   = "Ubuntu 20.04" // Имя темплейта //
      cpu            = 2                 // Количество ядер //
      cores          = 2
      ram            = 4096              // Размер ОЗУ //
    },
#
# Определение параметров для ВМ №3
#  
    {
      VmName         = "ter03"             // Имя ВМ и vAPP //
      StorageProfile = "Silver"          // Имя Storage Policy //
      CatalogName    = "01 Linux" // Имя каталога, где хранится темплейт //
      TemplateName   = "CentOS-8.2" // Имя темплейта //
      cpu            = 2                 // Количество ядер //
      cores          = 2
      ram            = 4096              // Размер ОЗУ //
    },
#
# Определение параметров для ВМ №4
#  
    {
      VmName         = "VM3"             // Имя ВМ и vAPP //
      StorageProfile = "Silver"          // Имя Storage Policy //
      CatalogName    = "MigrationFolder" // Имя каталога, где хранится темплейт //
      TemplateName   = "CentOS 7.7.1908" // Имя темплейта //
      cpu            = 2                 // Количество ядер //
      cores          = 2
      ram            = 2048              // Размер ОЗУ //
    },
#
# Определение параметров для ВМ №5
#  
    {
      VmName         = "VM4"             // Имя ВМ и vAPP //
      StorageProfile = "Silver"          // Имя Storage Policy //
      CatalogName    = "MigrationFolder" // Имя каталога, где хранится темплейт //
      TemplateName   = "CentOS 7.7.1908" // Имя темплейта //
      cpu            = 3                 // Количество ядер //
      cores          = 2
      ram            = 3072              // Размер ОЗУ //
    },
#
# Определение параметров для ВМ №6
#  
    {
      VmName         = "VM5"             // Имя ВМ и vAPP //
      StorageProfile = "Silver"          // Имя Storage Policy //
      CatalogName    = "MigrationFolder" // Имя каталога, где хранится темплейт //
      TemplateName   = "CentOS 7.7.1908" // Имя темплейта //
      cpu            = 1                 // Количество ядер //
      cores          = 2
      ram            = 1024              // Размер ОЗУ //
    },
#
# Определение параметров для ВМ №7
#  
    {
      VmName         = "VM6"             // Имя ВМ и vAPP //
      StorageProfile = "Silver"          // Имя Storage Policy //
      CatalogName    = "MigrationFolder" // Имя каталога, где хранится темплейт //
      TemplateName   = "CentOS 7.7.1908" // Имя темплейта //
      cpu            = 2                 // Количество ядер //
      cores          = 2
      ram            = 2048              // Размер ОЗУ //
    },
#
# Определение параметров для ВМ №8
#  
    {
      VmName         = "VM7"             // Имя ВМ и vAPP //
      StorageProfile = "Silver"          // Имя Storage Policy //
      CatalogName    = "MigrationFolder" // Имя каталога, где хранится темплейт //
      TemplateName   = "CentOS 7.7.1908" // Имя темплейта //
      cpu            = 3                 // Количество ядер //
      cores          = 2
      ram            = 3072              // Размер ОЗУ //
    },
#
# Определение параметров для ВМ №9
#  
    {
      VmName         = "VM8"             // Имя ВМ и vAPP //
      StorageProfile = "Silver"          // Имя Storage Policy //
      CatalogName    = "MigrationFolder" // Имя каталога, где хранится темплейт //
      TemplateName   = "CentOS 7.7.1908" // Имя темплейта //
      cpu            = 1                 // Количество ядер //
      cores          = 2
      ram            = 1024              // Размер ОЗУ //
    },
#
# Определение параметров для ВМ №10
#  
    {
      VmName         = "VM9"             // Имя ВМ и vAPP //
      StorageProfile = "Silver"          // Имя Storage Policy //
      CatalogName    = "MigrationFolder" // Имя каталога, где хранится темплейт //
      TemplateName   = "CentOS 7.7.1908" // Имя темплейта //
      cpu            = 3                 // Количество ядер //
      cores          = 2
      ram            = 3072              // Размер ОЗУ //
    }  
  ]
}
