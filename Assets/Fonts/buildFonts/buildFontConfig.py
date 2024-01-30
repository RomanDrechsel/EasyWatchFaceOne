font_basedir = "../"

avail_fonts = {
    "Komikazoom": "Komikazoom/KAMIKZOM.ttf",
    "GoD": "GrimoireOfDeath/GrimoireOfDeath-2O2jX.ttf",
    "Troika": "Troika/troika.otf",
    "Roboto": "Roboto/Roboto-Medium.ttf",
    "RobotoBold": "Roboto/Roboto-Black.ttf",
    "RobotoRegular": "Roboto/Roboto-Regular.ttf",
    "NotoSans": "Noto Sans/NotoSansKR-SemiBold.ttf",
    "Kanit": "Kanit/Kanit-Medium.ttf",
    "Consola": "ConsolaMono/ConsolaMono-Book.ttf",
    "ConsolaBold": "ConsolaMono/ConsolaMono-Bold.ttf",
    "Impossible": "Impossible/Impossible.ttf",
    "Typesauce": "Typesauce/Typesauce-2OX9w.ttf",
    "Normal": "Roboto/Roboto-Medium.ttf",
    "Small": "Roboto/Roboto-Medium.ttf",
    "Tiny": "Roboto/Roboto-Medium.ttf",
}

avail_codepoints = {
    "date": {
        "latin": "32,46-57,65-90,193-194,196,197,199,201,205,214,216,218,220,268,282,286,344,346,350,352,377,381",
        "cyrillic": "32,46-57,1030,1040-1046,1048-1060,1063,1066,1070-1071",
        "greek": "32,46-57,902,904,910,913-917,919,921-925,927-929,931-934",
        "logograms": "32,46-57,19968,19977,20108,20116,20845,21608,22235,22303,26085,26376,26408,27700,28779,36913,37329,44552,47785,49688,50900,51068,53664,54868",
        "thai": "32,46-57,3585,3588,3592,3605,3608,3614,3617-3618,3620,3624,3626,3629,3634,3648",
    },
    "hours": {
        "hours": "48-57"
    },
    "minutes": {
        "minutes": "48-57"
    },
    "seconds": {
        "seconds": "48-57,65,77,80"
    },
    "text": {
        "normal": "32,45,48-57",
        "small": "32,37,40-41,43-46,48-57,84,98,100,102,105,107,109,112,114,116,176",
        "tiny": "32,37,40-41,48-57,84,100,109"
    }
}

avail_charsets = {
    "lat": "latin",
    "cyr": "cyrillic",
    "gre": "greek",
    "log": "logograms",
    "tha": "thai",
    "hrs": "hours",
    "min": "minutes",
    "sec": "seconds",
    "nor": "normal",
    "sma": "small",
    "tin": "tiny"
}

avail_configs = {
    "date": {
        "Komikazoom": {
            "Normal": {
                "Fontsize": 42,
                "MaxHeight": 512,
            },
            "Small": {
                "Fontsize": 30,
                "MaxHeight": 256
            }
        },
        "GoD": {
            "Normal": {
                "Fontsize": 48,
                "MaxHeight": 512,
            },
            "Small": {
                "Fontsize": 32,
                "MaxHeight": 256
            }
        },
        "Trokia": {
            "Normal": {
                "Fontsize": 48,
                "MaxHeight": 512,
            },
            "Small": {
                "Fontsize": 32,
                "MaxHeight": 256
            }
        },
        "Roboto": {
            "Normal": {
                "Fontsize": 42,
                "MaxHeight": 512,
            },
            "Small": {
                "Fontsize": 32,
                "MaxHeight": 256
            }        
        },
        "NotoSans": {
            "Normal": {
                "Fontsize": 38,
                "MaxHeight": 512,
            },
            "Small": {
                "Fontsize": 28,
                "MaxHeight": 256
            }
        },
        "Kanit": {
            "Normal": {
                "Fontsize": 46,
                "MaxHeight": 512
            },
            "Small": {
                "Fontsize": 32,
                "MaxHeight": 256
            }
        }
    },
    "hours": {
        "ConsolaBold": {
            "Normal": {
                "Fontsize": 98,
                "MaxHeight": 512,
            },
            "Small": {
                "Fontsize": 70,
                "MaxHeight": 256
            }
        },
        "Impossible": {
            "Normal": {
                "Fontsize": 104,
                "MaxHeight": 512,
            },
            "Small": {
                "Fontsize": 70,
                "MaxHeight": 256
            }
        },
        "Komikazoom": {
            "Normal": {
                "Fontsize": 96,
                "MaxHeight": 512,
            },
            "Small": {
                "Fontsize": 66,
                "MaxHeight": 256
            }
        },
        "RobotoBold": {
            "Normal": {
                "Fontsize": 96,
                "MaxHeight": 512,
            },
            "Small": {
                "Fontsize": 66,
                "MaxHeight": 256
            }
        },
        "Typesauce": {
            "Normal": {
                "Fontsize": 76,
                "MaxHeight": 512,
            },
            "Small": {
                "Fontsize": 60,
                "MaxHeight": 256,
            }
        }
    },
    "minutes": {
        "RobotoRegular": {
            "Normal": {
                "Fontsize": 96,
                "MaxHeight": 512,
            },
        }
    },
    "seconds": {
        "Consola": {
            "Normal": {
                "Fontsize": 42,
                "MaxHeight": 256,
            },
            "Small": {
                "Fontsize": 26,
                "MaxHeight": 128
            }
        },
        "Impossible": {
            "Normal": {
                "Fontsize": 44,
                "MaxHeight": 256,
            },
            "Small": {
                "Fontsize": 28,
                "MaxHeight": 128
            }
        },
        "Komikazoom": {
            "Normal": {
                "Fontsize": 40,
                "MaxHeight": 256,
            },
            "Small": {
                "Fontsize": 26,
                "MaxHeight": 128
            }
        },
        "Roboto": {
            "Normal": {
                "Fontsize": 40,
                "MaxHeight": 256,
            },
            "Small": {
                "Fontsize": 26,
                "MaxHeight": 128
            }
        },
        "Typesauce": {
            "Normal": {
                "Fontsize": 32,
                "MaxHeight": 256,
            },
            "Small": {
                "Fontsize": 22,
                "MaxHeight": 128,
            }
        }
    },
    "text": {
        "Normal": {
            "Normal": {
                "Fontsize": 38,
                "MaxHeight": 256,
            },
            "Small": {
                "Fontsize": 28,
                "MaxHeight": 128,
            }
        },
        "Small": {
            "Normal": {
                "Fontsize": 24,
                "MaxHeight": 256,
            },
            "Small": {                
                "Fontsize": 16,
                "MaxHeight": 128,
            }
        },
        "Tiny": {
            "Normal": {
                "Fontsize": 20,
                "MaxHeight": 256,
            }
        }
    }
}