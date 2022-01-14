$MicrosoftNet = 'HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319'
$SchUseStrongCrypto_nom = 'SchUseStrongCrypto'
$SchUseStrongCrypto_valor = '00000001'
$WowNet = 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework\v4.0.30319'
$tls12 = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2'
$tls12client = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client'
$tls12server = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server'
$DisabledByDefault_nom = 'DisabledByDefault'
$DisabledByDefault_valor = '00000000'
$Enabled_nom = 'Enabled'
$Enabled_valor = '4294967295'
# FUNCIÓ PER ESCRIURE ELS ERRORS EN PANTALLA
function Escriure-Error($text)
{
    Write-Host $text -ForegroundColor Red -BackgroundColor Black
}

# FUNCIÓ QUE VALIDA QUE LES 2 CLAUS IMPRESCINDIBLES DEL .NET
# EXISTEIXIN, SINO ESTAN ES DONA PER FER QUE S'EXECUTA
# L'ESCRIPT ON NO CORRESPON
function Net-Installat()
{
    if(!(Test-Path -Path $MicrosoftNet) -or !(Test-Path -Path $WowNet))
    {
        Escriure-Error -text "NO EXISTEIX EL REGISTRE 'HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319' O EL REGISTRE 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework\v4.0.30319'"
        Escriure-Error -text "EL .NET NO ESTÀ INSTAL·LAT"
        Escriure-Error -text "L'ESCRIPT HA FINALITZAT"
        Exit
    }
}

# EN CAS QUE LES RUTES TLS1.2 I TLS12\CLIENT TLS\SERVER
# NO EXISTEIXIN, LES CREA DE NOU.
function Crear-Claus()
{
    if(!(test-path -Path $tls12))
    {
        #Remove-Item -Path $tls12
        New-Item -Path $tls12
    }
    if(!(test-path -Path $tls12client))
    {
        #Remove-Item -Path $tls12client
        New-Item -Path $tls12client
    }
    if(!(test-path -Path $tls12server))
    {
        #Remove-Item -Path $tls12server
        New-Item -Path $tls12server
    }
    return 'True'
}

# FUNCIÓ QUE ELIMINA I CREA REGISTRES
function Crear-Registres()
{
    Remove-ItemProperty -Path $MicrosoftNet -Name $SchUseStrongCrypto_nom -ErrorAction Ignore
    New-ItemProperty -Path $MicrosoftNet -Name $SchUseStrongCrypto_nom -Value $SchUseStrongCrypto_valor -PropertyType DWord

    Remove-ItemProperty -Path $WowNet -Name $SchUseStrongCrypto_nom -ErrorAction Ignore
    New-ItemProperty -Path $WowNet -Name $SchUseStrongCrypto_nom -Value $SchUseStrongCrypto_valor -PropertyType DWord

    Remove-ItemProperty -Path $tls12client -Name $Enabled_nom -ErrorAction Ignore
    New-ItemProperty -Path $tls12client -Name $Enabled_nom -Value $Enabled_valor -PropertyType DWord

    Remove-ItemProperty -Path $tls12client -Name $DisabledByDefault_nom -ErrorAction Ignore
    New-ItemProperty -Path $tls12client -Name $DisabledByDefault_nom -Value $DisabledByDefault_valor -PropertyType DWord

    Remove-ItemProperty -Path $tls12server -Name $Enabled_nom -ErrorAction Ignore
    New-ItemProperty -Path $tls12server -Name $Enabled_nom -Value $Enabled_valor -PropertyType DWord

    Remove-ItemProperty -Path $tls12server -Name $DisabledByDefault_nom -ErrorAction Ignore
    New-ItemProperty -Path $tls12server -Name $DisabledByDefault_nom -Value $DisabledByDefault_valor -PropertyType DWord
}

# FUNCIÓ QUE CENTRALITZA TOT EL PROCÉS
function Habilitar-TLS12 ()
{
    Net-Installat
    Crear-Claus
    Crear-Registres
}

Habilitar-TLS12