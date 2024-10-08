fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'

description 'luxr-bountyhunter'
version '1.0.2'

shared_scripts {
    '@ox_lib/init.lua',
    '@luxr-core/shared/locale.lua',
    'locales/en.lua', -- Preferred language
    'config.lua',
}

client_scripts {
    'client/client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua',
    'server/versionchecker.lua'
}

dependencies {
    'luxr-core',
    'luxr-target',
    'ox_lib',
}

lua54 'yes'
