import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;

/**
 * Parses icon names from a JSON dictionary into a ResourceId.
 */
class IconParser {

    // For some icons we have different treatment for AMOLED/LCD devices
    // with 64K colors and MIP devices with 64 colors.
    // On CIQ 5.0.0+ devices, AMOLED/LCD devices have a System.getDisplayMode
    // functions. Prior to that, the required burn in protection is a good
    // indication for the device being AMOLED
    private static function has64kColors() as Boolean {
        return System has :getDisplayMode || System.getDeviceSettings().requiresBurnInProtection;
    }

    // Get the ResourceId for the icon
    // Icon is optional, so this function may return null
    // If available we also apply the item state
    public static function parse( iconType as String, item as Item? ) as ResourceId? {
        if( ! iconType.equals( "" ) ) {
            var itemState = "";
            if( item != null ) {
                itemState = item.getState();
            }
            switch( iconType ) {
                case "slider":
                case "light": {
                    var numericItemState = itemState.toNumber();
                    
                    if( numericItemState == null ) {
                        if( itemState.equals( SwitchItem.ITEM_STATE_OFF ) ) {
                            return Rez.Drawables.menuLight00;
                        } else {
                            return Rez.Drawables.menuLight10;
                        }
                    } else {
                        if( has64kColors() ) {
                            if( numericItemState >= 100 ) {
                                return Rez.Drawables.menuLight10;
                            } else if( numericItemState >= 90 ) {
                                return Rez.Drawables.menuLight09;
                            } else if( numericItemState >= 80 ) {
                                return Rez.Drawables.menuLight08;
                            } else if( numericItemState >= 70 ) {
                                return Rez.Drawables.menuLight07;
                            } else if( numericItemState >= 60 ) {
                                return Rez.Drawables.menuLight06;
                            } else if( numericItemState >= 50 ) {
                                return Rez.Drawables.menuLight05;
                            } else if( numericItemState >= 40 ) {
                                return Rez.Drawables.menuLight04;
                            } else if( numericItemState >= 30 ) {
                                return Rez.Drawables.menuLight03;
                            } else if( numericItemState >= 20 ) {
                                return Rez.Drawables.menuLight02;
                            } else if( numericItemState >= 10 ) {
                                return Rez.Drawables.menuLight01;
                            } else {
                                return Rez.Drawables.menuLight00;
                            }
                        } else {
                            if( numericItemState > 0 ) {
                                return Rez.Drawables.menuLight10;
                            } else {
                                return Rez.Drawables.menuLight00;
                            }
                        }
                    }
                }

                case "lightbulb": return Rez.Drawables.menuLight10;

                case "garagedoor": {
                    var numericItemState = itemState.toNumber();
                    
                    if( numericItemState == null ) {
                        if( itemState.equals( SwitchItem.ITEM_STATE_CLOSED ) ) {
                            return Rez.Drawables.menuGaragedoor10;
                        } else if( itemState.equals( SwitchItem.ITEM_STATE_OPEN ) ) {
                            return Rez.Drawables.menuGaragedoor00;
                        } else {
                            return Rez.Drawables.menuGaragedoor05;
                        }
                    } else {
                        if( numericItemState >= 100 ) {
                            return Rez.Drawables.menuGaragedoor10;
                        } else if( numericItemState >= 90 ) {
                            return Rez.Drawables.menuGaragedoor09;
                        } else if( numericItemState >= 80 ) {
                            return Rez.Drawables.menuGaragedoor08;
                        } else if( numericItemState >= 70 ) {
                            return Rez.Drawables.menuGaragedoor07;
                        } else if( numericItemState >= 60 ) {
                            return Rez.Drawables.menuGaragedoor06;
                        } else if( numericItemState >= 50 ) {
                            return Rez.Drawables.menuGaragedoor05;
                        } else if( numericItemState >= 40 ) {
                            return Rez.Drawables.menuGaragedoor04;
                        } else if( numericItemState >= 30 ) {
                            return Rez.Drawables.menuGaragedoor03;
                        } else if( numericItemState >= 20 ) {
                            return Rez.Drawables.menuGaragedoor02;
                        } else if( numericItemState >= 10 ) {
                            return Rez.Drawables.menuGaragedoor01;
                        } else {
                            return Rez.Drawables.menuGaragedoor00;
                        }
                    }
                }

                case "blinds":
                case "rollershutter": {
                    var numericItemState = itemState.toNumber();
                    
                    if( numericItemState == null || numericItemState >= 100 ) {
                        return Rez.Drawables.menuRollershutter10;
                    } else if( numericItemState >= 90 ) {
                        return Rez.Drawables.menuRollershutter09;
                    } else if( numericItemState >= 80 ) {
                        return Rez.Drawables.menuRollershutter08;
                    } else if( numericItemState >= 70 ) {
                        return Rez.Drawables.menuRollershutter07;
                    } else if( numericItemState >= 60 ) {
                        return Rez.Drawables.menuRollershutter06;
                    } else if( numericItemState >= 50 ) {
                        return Rez.Drawables.menuRollershutter05;
                    } else if( numericItemState >= 40 ) {
                        return Rez.Drawables.menuRollershutter04;
                    } else if( numericItemState >= 30 ) {
                        return Rez.Drawables.menuRollershutter03;
                    } else if( numericItemState >= 20 ) {
                        return Rez.Drawables.menuRollershutter02;
                    } else if( numericItemState >= 10 ) {
                        return Rez.Drawables.menuRollershutter01;
                    } else {
                        return Rez.Drawables.menuRollershutter00;
                    }
                }
 
                case "poweroutlet": {
                    if( itemState.equals( SwitchItem.ITEM_STATE_ON ) ) {
                        return Rez.Drawables.menuPowerOutletOn;
                    } else if( itemState.equals( SwitchItem.ITEM_STATE_OFF ) ) {
                        return Rez.Drawables.menuPowerOutletOff;
                    } else {
                        return Rez.Drawables.menuPowerOutlet;
                    }
                }

                case "door": {
                    if( itemState.equals( SwitchItem.ITEM_STATE_CLOSED ) ) {
                        return Rez.Drawables.menuDoorClosed;
                    } else {
                        return Rez.Drawables.menuDoorOpen;
                    }
                }

                case "frontdoor": {
                    if( itemState.equals( SwitchItem.ITEM_STATE_CLOSED ) ) {
                        return Rez.Drawables.menuFrontDoorClosed;
                    } else {
                        return Rez.Drawables.menuFrontDoorOpen;
                    }
                }

                case "window": {
                    var numericItemState = itemState.toNumber();
                    if( itemState.equals( SwitchItem.ITEM_STATE_OPEN ) || ( numericItemState != null && numericItemState > 0 ) ) {
                        return Rez.Drawables.menuWindowOpen;
                    } else {
                        return Rez.Drawables.menuWindowClosed;
                    }                
                }

                case "screen": {
                    if( itemState.equals( SwitchItem.ITEM_STATE_OFF ) ) {
                        return Rez.Drawables.menuScreenOff;
                    } else {
                        return Rez.Drawables.menuScreenOn;
                    }
                }

                case "temperature": {
                    return Rez.Drawables.menuTemperature;
                }

                case "humidity": {
                    var numericItemState = itemState.toNumber();
                    
                    if( numericItemState == null ) {
                        return Rez.Drawables.menuHumidity05;
                    } else {
                        if( numericItemState >= 100 ) {
                            return Rez.Drawables.menuHumidity10;
                        } else if( numericItemState >= 90 ) {
                            return Rez.Drawables.menuHumidity09;
                        } else if( numericItemState >= 80 ) {
                            return Rez.Drawables.menuHumidity08;
                        } else if( numericItemState >= 70 ) {
                            return Rez.Drawables.menuHumidity07;
                        } else if( numericItemState >= 60 ) {
                            return Rez.Drawables.menuHumidity06;
                        } else if( numericItemState >= 50 ) {
                            return Rez.Drawables.menuHumidity05;
                        } else if( numericItemState >= 40 ) {
                            return Rez.Drawables.menuHumidity04;
                        } else if( numericItemState >= 30 ) {
                            return Rez.Drawables.menuHumidity03;
                        } else if( numericItemState >= 20 ) {
                            return Rez.Drawables.menuHumidity02;
                        } else if( numericItemState >= 10 ) {
                            return Rez.Drawables.menuHumidity01;
                        } else {
                            return Rez.Drawables.menuHumidity00;
                        }
                    }
                }

                case "batterylevel": {
                    var numericItemState = itemState.toNumber();
                    
                    if( numericItemState == null ) {
                        return Rez.Drawables.menuBatteryLevel07;
                    } else {
                        if( numericItemState >= 100 ) {
                            return Rez.Drawables.menuBatteryLevel10;
                        } else if( numericItemState >= 90 ) {
                            return Rez.Drawables.menuBatteryLevel09;
                        } else if( numericItemState >= 80 ) {
                            return Rez.Drawables.menuBatteryLevel08;
                        } else if( numericItemState >= 70 ) {
                            return Rez.Drawables.menuBatteryLevel07;
                        } else if( numericItemState >= 60 ) {
                            return Rez.Drawables.menuBatteryLevel06;
                        } else if( numericItemState >= 50 ) {
                            return Rez.Drawables.menuBatteryLevel05;
                        } else if( numericItemState >= 40 ) {
                            return Rez.Drawables.menuBatteryLevel04;
                        } else if( numericItemState >= 30 ) {
                            return Rez.Drawables.menuBatteryLevel03;
                        } else if( numericItemState >= 20 ) {
                            return Rez.Drawables.menuBatteryLevel02;
                        } else if( numericItemState >= 10 ) {
                            return Rez.Drawables.menuBatteryLevel01;
                        } else {
                            return Rez.Drawables.menuBatteryLevel00;
                        }
                    }
                }

                case "lowbattery": return Rez.Drawables.menuBatteryLevel00;

                case "radiator": return Rez.Drawables.menuRadiator;

                case "mediacontrol": return Rez.Drawables.menuMediaControl;

                case "player": return Rez.Drawables.menuPlayer;

                case "soundvolume": {
                    var numericItemState = itemState.toNumber();
                    
                    if( numericItemState == null ) {
                        return Rez.Drawables.menuSoundVolume10;
                    } else {
                        if( numericItemState >= 100 ) {
                            return Rez.Drawables.menuSoundVolume10;
                        } else if( numericItemState >= 70 ) {
                            return Rez.Drawables.menuSoundVolume07;
                        } else if( numericItemState >= 40 ) {
                            return Rez.Drawables.menuSoundVolume04;
                        } else {
                            return Rez.Drawables.menuSoundVolume00;
                        }
                    }
                }

                case "soundvolume_mute": {
                    if( itemState.equals( SwitchItem.ITEM_STATE_ON ) ) {
                        return Rez.Drawables.menuSoundVolumeMuteOn;
                    } else {
                        return Rez.Drawables.menuSoundVolumeMuteOff;
                    }
                }

                case "motion": return Rez.Drawables.menuMotion;

                case "heating": {
                    if( itemState.equals( SwitchItem.ITEM_STATE_OFF ) ) {
                        return Rez.Drawables.menuHeatingOff;
                    } else {
                        return Rez.Drawables.menuHeatingOn;
                    }
                }

                case "terrace": return Rez.Drawables.menuTerrace;

                case "snow": return Rez.Drawables.menuSnow;

            }
        }
        return null;
    }
}