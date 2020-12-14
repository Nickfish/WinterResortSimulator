-- This is a sample Transport Mission
-- Made by Paul Masan (Paulchen/Raining-Cloud)
-- My GitHub for more cool stuff: https://github.com/Raining-Cloud
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- -----------------------NOT TESTED BUT IT SHOULD WORK------------------------
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
ModLoader.addContent(
    "mission",
    {
        contentName = "mission01",
        author = "Author Name",
        class = IngameMission,
        title = "Mission Title",
        fullDesc = "This is a sample Mission. You can add your description here",
        duration = IngameMission.getTransportMissionDuration,
        remuneration = IngameMission.getTransportMissionRemuneration,
        prerequisites = IngameMission.getTransportMissionPrerequisites,
        relativeFrequency = function()
            return 9999
        end,
        extraReward = IngameMission.getTransportMissionExtraReward,
        moneyPerMinute = 2000,
        -- Add your Map ID here
        compatibleMapIds = {
            "HR_HallsteinSeason2"
        },
        variables = {
            -- all positions where the mission shall start from, to add variety you can add multiple tables
            fetchFrom = {
                {
                    vehiclePosition = Vector3:new(131, 421, 856),
                    prefabPosition = Vector3:new(113, 421, 855),
                    label = "Hotel Central",
                    relativeFrequency = 1
                }
            },
            -- all positions where the mission ends, to add variety you can add multiple tables
            deliverTo = {
                {
                    vehiclePosition = Vector3:new(975, 584, 269),
                    prefabPosition = Vector3:new(975, 584, 269),
                    label = "Almrestaurant",
                    relativeFrequency = 1
                }
            },
            -- the vehicles that can be used for this mission
            vehicle = {
                {
                    vehicleType = "default.MarmottaHazard",
                    avgSpeed = 40 * 0.85,
                    extraTime = 50,
                    relativeFrequency = 1,
                    locked = IngameMission.isVehicleLocked
                },
                {
                    vehicleType = "default.Vattenmask",
                    avgSpeed = 30 * 0.85,
                    extraTime = 45,
                    relativeFrequency = 1,
                    locked = IngameMission.isVehicleLocked
                },
                {
                    vehicleType = "default.MarmottaTiger",
                    avgSpeed = 35 * 0.85,
                    extraTime = 47,
                    relativeFrequency = 1,
                    locked = IngameMission.isVehicleLocked
                },
                --Not sure if the pistenbully work but should be possible
                {
                    vehicleType = "default.pistenbully100",
                    avgSpeed = 35 * 0.40,
                    extraTime = 8,
                    relativeFrequency = 1,
                    locked = IngameMission.isVehicleLocked
                },
                {
                    vehicleType = "default.pistenbully600",
                    avgSpeed = 35 * 0.40,
                    extraTime = 8,
                    relativeFrequency = 1,
                    locked = IngameMission.isVehicleLocked
                },
                {
                    vehicleType = "default.pistenbully600W",
                    avgSpeed = 35 * 0.40,
                    extraTime = 8,
                    relativeFrequency = 1,
                    locked = IngameMission.isVehicleLocked
                }
            },
            -- the transport object which will be spawned
            prefabType = {
                {label = "$mission_prefab_packets", prefabName = "internal/deliveryPackage", timeCoeff = 1.5},
                {label = "$mission_prefab_fireExtinguisher", prefabName = "internal/missions/fireExtinguisher"},
                {label = "$mission_prefab_wheelieBin", prefabName = "internal/missions/wheelieBin"},
                {label = "$mission_prefab_plasticBarrel", prefabName = "internal/missions/plasticBarrel"},
                {label = "$mission_prefab_metalBarrel", prefabName = "internal/missions/metalBarrel"}
            }
        },
        events = {
            -- spawn the transport object at the given location at the start of the mission
            start = function(self, properties)
                self.packageId =
                    DeliverySystem.spawnObject(
                    properties.prefabType.prefabName,
                    properties.fetchFrom.prefabPosition,
                    properties.fetchFrom.prefabRotation or 0
                )
            end,
            -- despawn at the end of the mission
            destroy = function(self, properties)
                DeliverySystem.destroyAllObjects()
            end
        },
        -- task stack shows the next task for the player
        tasks = function(self, properties)
            return {
                {
                    type = "showMissionInfo"
                },
                -- go to the start point
                {
                    type = "trigger",
                    title = l10n.format(
                        "transportMission01_stack_1a_pickUp",
                        l10n.getDollar(properties.fetchFrom.label)
                    ),
                    message = l10n.format(
                        "transportMission01_stack_1b_driveThere",
                        VehicleManager:getVehicleTypeName(properties.vehicle.vehicleType)
                    ),
                    position = properties.fetchFrom.vehiclePosition,
                    validateObjectId = IngameMission.validateMissionVehicle
                },
                -- start the countdown
                {
                    type = "startCountdown"
                },
                -- show the transport object position
                {
                    type = "hint",
                    title = l10n.format(
                        "transportMission01_stack_1a_pickUp",
                        l10n.getDollar(properties.fetchFrom.label)
                    ),
                    message = l10n.format(
                        "transportMission01_stack_1c_load",
                        l10n.getDollar(properties.prefabType.label)
                    ),
                    checkSkip = DeliverySystem.allPackagesOnVehicle
                },
                --show the target location
                {
                    type = "trigger",
                    title = l10n.format(
                        "transportMission01_stack_2a_deliver",
                        l10n.getDollar(properties.deliverTo.label)
                    ),
                    message = "$transportMission01_stack_2b_driveToMarkedSpot",
                    position = properties.deliverTo.vehiclePosition,
                    validateObjectId = IngameMission.validateMissionVehicle
                },
                -- deliver the transport object to the target location
                {
                    type = "hint",
                    title = "$transportMission01_stack_3a_pickUpPacket",
                    message = "$transportMission01_stack_3b_unloadPacket",
                    checkSkip = IngameMission.anyPackagePickedUp
                },
                --put the transport object in the deliver point
                {
                    type = "trigger",
                    title = "$transportMission01_stack_3c_deliverPacket",
                    message = "$transportMission01_stack_3d_deliverPacket2",
                    position = properties.deliverTo.prefabPosition,
                    validateObjectId = IngameMission.packageDrop
                },
                -- stop the countdown
                {
                    type = "stopCountdown"
                }
            }
        end,
    }
)
