USE [GRAWE_DEV]

GO
SET IDENTITY_INSERT [dbo].[gr_hierarchy_groups] ON 
GO
INSERT [dbo].[gr_hierarchy_groups] ([id], [name], [level_type], [parent_id], [created_at]) VALUES (1, N'Direktor Prodaje', 1, NULL, CAST(N'2025-02-20T11:16:11.513' AS DateTime))
GO
INSERT [dbo].[gr_hierarchy_groups] ([id], [name], [level_type], [parent_id], [created_at]) VALUES (2, N'Eksterna Prodaja', 2, 1, CAST(N'2025-02-20T11:16:11.530' AS DateTime))
GO
INSERT [dbo].[gr_hierarchy_groups] ([id], [name], [level_type], [parent_id], [created_at]) VALUES (3, N'Interna Prodaja', 2, 1, CAST(N'2025-02-20T11:16:11.530' AS DateTime))
GO
INSERT [dbo].[gr_hierarchy_groups] ([id], [name], [level_type], [parent_id], [created_at]) VALUES (4, N'Motoprodaja', 3, 3, CAST(N'2025-02-20T11:16:11.540' AS DateTime))
GO
INSERT [dbo].[gr_hierarchy_groups] ([id], [name], [level_type], [parent_id], [created_at]) VALUES (5, N'Zeleni Karton', 3, 3, CAST(N'2025-02-20T11:16:11.540' AS DateTime))
GO
INSERT [dbo].[gr_hierarchy_groups] ([id], [name], [level_type], [parent_id], [created_at]) VALUES (6, N'Imovina', 3, 3, CAST(N'2025-02-20T11:16:11.540' AS DateTime))
GO
INSERT [dbo].[gr_hierarchy_groups] ([id], [name], [level_type], [parent_id], [created_at]) VALUES (7, N'Osiguranje Vozila', 3, 2, CAST(N'2025-02-20T11:16:11.540' AS DateTime))
GO
INSERT [dbo].[gr_hierarchy_groups] ([id], [name], [level_type], [parent_id], [created_at]) VALUES (8, N'Putno Osiguranje', 3, 2, CAST(N'2025-02-20T11:16:11.540' AS DateTime))
GO
INSERT [dbo].[gr_hierarchy_groups] ([id], [name], [level_type], [parent_id], [created_at]) VALUES (9, N'Nezgodno Osiguranje', 3, 2, CAST(N'2025-02-20T11:16:11.540' AS DateTime))
GO
INSERT [dbo].[gr_hierarchy_groups] ([id], [name], [level_type], [parent_id], [created_at]) VALUES (10, N'Podgorica', 4, 4, CAST(N'2025-02-20T11:16:11.550' AS DateTime))
GO
INSERT [dbo].[gr_hierarchy_groups] ([id], [name], [level_type], [parent_id], [created_at]) VALUES (11, N'Herceg Novi', 4, 4, CAST(N'2025-02-20T11:16:11.550' AS DateTime))
GO
INSERT [dbo].[gr_hierarchy_groups] ([id], [name], [level_type], [parent_id], [created_at]) VALUES (12, N'Budva', 4, 4, CAST(N'2025-02-20T11:16:11.550' AS DateTime))
GO
INSERT [dbo].[gr_hierarchy_groups] ([id], [name], [level_type], [parent_id], [created_at]) VALUES (13, N'Cetinje', 4, 7, CAST(N'2025-02-20T11:16:11.550' AS DateTime))
GO
INSERT [dbo].[gr_hierarchy_groups] ([id], [name], [level_type], [parent_id], [created_at]) VALUES (14, N'Bar', 4, 7, CAST(N'2025-02-20T11:16:11.550' AS DateTime))
GO
INSERT [dbo].[gr_hierarchy_groups] ([id], [name], [level_type], [parent_id], [created_at]) VALUES (15, N'Stari Aerodrom', 5, 10, CAST(N'2025-02-20T11:16:11.560' AS DateTime))
GO
INSERT [dbo].[gr_hierarchy_groups] ([id], [name], [level_type], [parent_id], [created_at]) VALUES (16, N'Nova Settlements', 5, 10, CAST(N'2025-02-20T11:16:11.560' AS DateTime))
GO
INSERT [dbo].[gr_hierarchy_groups] ([id], [name], [level_type], [parent_id], [created_at]) VALUES (17, N'Centar', 5, 10, CAST(N'2025-02-20T11:16:11.560' AS DateTime))
GO
INSERT [dbo].[gr_hierarchy_groups] ([id], [name], [level_type], [parent_id], [created_at]) VALUES (18, N'Igalo', 5, 11, CAST(N'2025-02-20T11:16:11.560' AS DateTime))
GO
INSERT [dbo].[gr_hierarchy_groups] ([id], [name], [level_type], [parent_id], [created_at]) VALUES (19, N'Topla', 5, 11, CAST(N'2025-02-20T11:16:11.560' AS DateTime))
GO
INSERT [dbo].[gr_hierarchy_groups] ([id], [name], [level_type], [parent_id], [created_at]) VALUES (21, N'New NEW Sales Region', 4, 3, CAST(N'2025-02-25T16:57:55.887' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[gr_hierarchy_groups] OFF
GO
SET IDENTITY_INSERT [dbo].[gr_hierarchy_vkto_mapping] ON 
GO
INSERT [dbo].[gr_hierarchy_vkto_mapping] ([id], [group_id], [vkto], [created_at]) VALUES (6, 15, N'122', CAST(N'2025-02-26T11:04:01.830' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[gr_hierarchy_vkto_mapping] OFF
GO
INSERT [dbo].[gr_user_hierarchy_groups] ([user_id], [group_id], [created_at]) VALUES (1, 1, CAST(N'2025-02-26T10:51:28.827' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[gr_pairing_permission_groups_permission] ON 
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1200, 1, 23)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1201, 1, 24)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1203, 1, 9)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (4, 1, 26)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (5, 1, 27)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (6, 1, 28)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (7, 1, 34)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (8, 1, 41)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (9, 1, 42)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (10, 1022, 42)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (11, 1, 36)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1158, 3, 4)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1171, 3, 15)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1204, 1, 8)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1206, 1, 12)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1207, 1, 13)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (17, 1, 31)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (18, 1, 32)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (19, 1, 33)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (20, 1, 35)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (21, 1, 37)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (22, 1, 39)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (23, 1, 40)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (24, 1, 38)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1191, 1, 14)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1186, 1, 10)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1205, 1, 11)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1192, 1, 15)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1193, 1, 16)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1172, 3, 14)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1173, 3, 17)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1196, 1, 19)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1197, 1, 20)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1174, 3, 18)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1181, 1, 5)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1083, 3, 16)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1086, 3, 19)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1088, 3, 21)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1182, 1, 4)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1183, 1, 3)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1194, 1, 17)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1195, 1, 18)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1156, 3, 2)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1157, 3, 3)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1164, 3, 5)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1074, 3, 7)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1168, 3, 11)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1169, 3, 12)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1170, 3, 13)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1177, 1, 1)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1178, 1, 2)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1166, 3, 9)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1162, 3, 1)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1165, 3, 8)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1167, 3, 10)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1190, 1, 7)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1198, 1, 21)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1199, 1, 22)
GO
INSERT [dbo].[gr_pairing_permission_groups_permission] ([id], [id_permission_group], [id_permission]) VALUES (1202, 1, 25)
GO
SET IDENTITY_INSERT [dbo].[gr_pairing_permission_groups_permission] OFF
GO
SET IDENTITY_INSERT [dbo].[gr_pairing_permisson_property_list] ON 
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (1, 2, 1)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (2, 2, 2)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (3, 2, 3)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (4, 2, 4)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (5, 2, 5)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (6, 2, 6)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (7, 2, 7)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (8, 2, 8)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (9, 2, 9)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (10, 2, 10)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (11, 1, 17)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (12, 1, 18)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (13, 1, 19)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (14, 1, 20)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (15, 1, 21)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (16, 1, 22)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (17, 1, 23)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (18, 1, 24)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (19, 1, 25)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (20, 1, 26)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (21, 5, 27)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (22, 5, 28)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (23, 5, 29)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (24, 5, 30)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (25, 5, 31)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (26, 5, 32)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (27, 5, 33)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (28, 5, 34)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (29, 5, 35)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (30, 5, 36)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (31, 5, 37)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (32, 5, 38)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (33, 5, 39)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (34, 5, 40)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (35, 5, 41)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (36, 5, 42)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (37, 5, 43)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (38, 5, 44)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (39, 5, 45)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (40, 5, 46)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (41, 3, 47)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (42, 4, 48)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (116, 19, 102)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (112, 15, 99)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (113, 19, 97)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (114, 19, 100)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (62, 8, 49)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (63, 8, 50)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (64, 8, 51)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (65, 8, 52)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (66, 8, 53)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (67, 8, 54)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (68, 8, 55)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (69, 8, 56)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (70, 8, 57)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (71, 9, 58)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (72, 9, 59)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (73, 9, 60)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (74, 9, 61)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (75, 9, 62)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (76, 9, 63)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (77, 9, 64)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (78, 9, 65)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (79, 9, 66)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (80, 11, 67)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (81, 10, 68)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (82, 12, 69)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (83, 12, 70)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (84, 12, 71)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (85, 12, 72)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (86, 12, 73)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (87, 13, 74)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (88, 13, 75)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (89, 13, 76)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (90, 13, 77)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (91, 13, 78)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (92, 13, 79)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (93, 13, 80)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (94, 13, 81)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (95, 14, 82)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (96, 14, 83)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (97, 14, 84)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (98, 14, 85)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (99, 15, 86)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (100, 15, 87)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (101, 15, 88)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (102, 15, 89)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (103, 19, 90)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (104, 19, 91)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (105, 19, 92)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (106, 19, 93)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (107, 19, 94)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (108, 19, 95)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (109, 19, 96)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (110, 19, 97)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (117, 19, 103)
GO
INSERT [dbo].[gr_pairing_permisson_property_list] ([id], [id_permission], [id_permission_property]) VALUES (118, 19, 104)
GO
SET IDENTITY_INSERT [dbo].[gr_pairing_permisson_property_list] OFF
GO
SET IDENTITY_INSERT [dbo].[gr_pairing_users_groups_permission] ON 
GO
INSERT [dbo].[gr_pairing_users_groups_permission] ([id], [user_id], [permission_group_id]) VALUES (1024, 20, 1)
GO
INSERT [dbo].[gr_pairing_users_groups_permission] ([id], [user_id], [permission_group_id]) VALUES (1022, 1, 1)
GO
INSERT [dbo].[gr_pairing_users_groups_permission] ([id], [user_id], [permission_group_id]) VALUES (5, 1, 2)
GO
INSERT [dbo].[gr_pairing_users_groups_permission] ([id], [user_id], [permission_group_id]) VALUES (8, 6, 3)
GO
INSERT [dbo].[gr_pairing_users_groups_permission] ([id], [user_id], [permission_group_id]) VALUES (16, 14, 1)
GO
INSERT [dbo].[gr_pairing_users_groups_permission] ([id], [user_id], [permission_group_id]) VALUES (17, 15, 3)
GO
INSERT [dbo].[gr_pairing_users_groups_permission] ([id], [user_id], [permission_group_id]) VALUES (1017, 16, 3)
GO
INSERT [dbo].[gr_pairing_users_groups_permission] ([id], [user_id], [permission_group_id]) VALUES (1018, 17, 3)
GO
INSERT [dbo].[gr_pairing_users_groups_permission] ([id], [user_id], [permission_group_id]) VALUES (1019, 18, 3)
GO
INSERT [dbo].[gr_pairing_users_groups_permission] ([id], [user_id], [permission_group_id]) VALUES (1020, 19, 3)
GO
SET IDENTITY_INSERT [dbo].[gr_pairing_users_groups_permission] OFF
GO
SET IDENTITY_INSERT [dbo].[gr_permission] ON 
GO
INSERT [dbo].[gr_permission] ([id], [route], [visibility], [method], [name], [description]) VALUES (1, N'/api/v1/policies/:id/history', 1, N'get', N'Istorija polise', N'Tabela istorije polise')
GO
INSERT [dbo].[gr_permission] ([id], [route], [visibility], [method], [name], [description]) VALUES (2, N'/api/v1/policies/:id/info', 1, N'get', N'Osnovna polisa', N'Osnovne informacije o polisi')
GO
INSERT [dbo].[gr_permission] ([id], [route], [visibility], [method], [name], [description]) VALUES (3, N'/api/v1/policies/:id/history/xls/download', 1, N'get', N'XLS download', N'XLS download istorije polise')
GO
INSERT [dbo].[gr_permission] ([id], [route], [visibility], [method], [name], [description]) VALUES (4, N'/api/v1/policies/:id/history/pdf/download', 1, N'get', N'PDF export', N'PDF export polise')
GO
INSERT [dbo].[gr_permission] ([id], [route], [visibility], [method], [name], [description]) VALUES (5, N'/api/v1/policies/:id/analytics/info', 1, N'get', N'Analitika polise', N'Analiticki podaci jedne polise')
GO
INSERT [dbo].[gr_permission] ([id], [route], [visibility], [method], [name], [description]) VALUES (6, N'/api/v1/policies/:id/analytics/all', 1, N'get', NULL, NULL)
GO
INSERT [dbo].[gr_permission] ([id], [route], [visibility], [method], [name], [description]) VALUES (7, N'/api/v1/clients/:id/analytics/all', 1, N'get', N'Osnovni klijent', N'Osnovni podaci klijenta')
GO
INSERT [dbo].[gr_permission] ([id], [route], [visibility], [method], [name], [description]) VALUES (8, N'/api/v1/client/:id/history', 1, N'get', N'getClientHistory', N'get client history')
GO
INSERT [dbo].[gr_permission] ([id], [route], [visibility], [method], [name], [description]) VALUES (9, N'/api/v1/client/:id/info', 1, N'get', N'getClientInfo', N'get client info')
GO
INSERT [dbo].[gr_permission] ([id], [route], [visibility], [method], [name], [description]) VALUES (10, N'/api/v1/client/:id/history/xls/download', 1, N'get', N'getClientHistoryExcelDownload', N'Download client history as Excel')
GO
INSERT [dbo].[gr_permission] ([id], [route], [visibility], [method], [name], [description]) VALUES (11, N'/api/v1/client/:id/history/pdf/download', 1, N'get', N'getClientHistoryPDFDownload', N'Download client history as PDF')
GO
INSERT [dbo].[gr_permission] ([id], [route], [visibility], [method], [name], [description]) VALUES (12, N'/api/v1/client/:id/analytics', 1, N'get', N'getClientAnalyticalInfo', N'get client analytical info')
GO
INSERT [dbo].[gr_permission] ([id], [route], [visibility], [method], [name], [description]) VALUES (13, N'/api/v1/client/policy/:id', 1, N'get', N'getClientPolicyAnalyticalInfo', N'get client policy analytical info')
GO
INSERT [dbo].[gr_permission] ([id], [route], [visibility], [method], [name], [description]) VALUES (14, N'/api/v1/errors/', 1, N'get', N'getAllEmployeeErrors', N'Get all employee errors')
GO
INSERT [dbo].[gr_permission] ([id], [route], [visibility], [method], [name], [description]) VALUES (15, N'/api/v1/errors/exceptions', 1, N'get', N'getAllExceptions', N'Get all exceptions')
GO
INSERT [dbo].[gr_permission] ([id], [route], [visibility], [method], [name], [description]) VALUES (16, N'/api/v1/errors/exceptions', 1, N'post', N'addErrorException', N'Add exception error')
GO
INSERT [dbo].[gr_permission] ([id], [route], [visibility], [method], [name], [description]) VALUES (17, N'/api/v1/errors/exceptions', 1, N'delete', N'deleteErrorException', N'Delete exception error')
GO
INSERT [dbo].[gr_permission] ([id], [route], [visibility], [method], [name], [description]) VALUES (18, N'/api/v1/errors/exceptions', 1, N'patch', N'updateErrorException', N'Update exception error')
GO
INSERT [dbo].[gr_permission] ([id], [route], [visibility], [method], [name], [description]) VALUES (19, N'/api/v1/reports/', 1, N'get', N'getReports', N'Get reports')
GO
INSERT [dbo].[gr_permission] ([id], [route], [visibility], [method], [name], [description]) VALUES (20, N'/api/v1/reports/', 1, N'post', N'createReport', N'Create a new report')
GO
INSERT [dbo].[gr_permission] ([id], [route], [visibility], [method], [name], [description]) VALUES (21, N'/api/v1/reports/xls/', 1, N'post', N'downloadExcel', N'Download filtered report as XLS')
GO
INSERT [dbo].[gr_permission] ([id], [route], [visibility], [method], [name], [description]) VALUES (22, N'/api/v1/reports/:id/', 1, N'patch', N'updateReport', N'Update report by ID')
GO
INSERT [dbo].[gr_permission] ([id], [route], [visibility], [method], [name], [description]) VALUES (23, N'/api/v1/reports/:id/', 1, N'delete', N'deleteReport', N'Delete report by ID')
GO
INSERT [dbo].[gr_permission] ([id], [route], [visibility], [method], [name], [description]) VALUES (24, N'/api/v1/permissions/groups/', 1, N'patch', N'updateGroups', N'Update Groups')
GO
INSERT [dbo].[gr_permission] ([id], [route], [visibility], [method], [name], [description]) VALUES (25, N'/api/v1/permissions/groups/:id/users', 1, N'patch', N'updateUsersGroups', N'Add/Remove Users From Group')
GO
SET IDENTITY_INSERT [dbo].[gr_permission] OFF
GO
SET IDENTITY_INSERT [dbo].[gr_permission_groups] ON 
GO
INSERT [dbo].[gr_permission_groups] ([id], [name], [permission]) VALUES (1, N'super admin', 1)
GO
INSERT [dbo].[gr_permission_groups] ([id], [name], [permission]) VALUES (3, N'testing_users', NULL)
GO
SET IDENTITY_INSERT [dbo].[gr_permission_groups] OFF
GO
SET IDENTITY_INSERT [dbo].[gr_permission_properties] ON 
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2110, 1, 1, 3, 112)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2111, 1, 1, 3, 99)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2112, 1, 1, 3, 100)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2113, 1, 1, 3, 101)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2114, 1, 1, 3, 102)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2115, 1, 1, 3, 95)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2116, 1, 1, 3, 96)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2117, 1, 1, 3, 97)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2118, 1, 1, 3, 98)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2152, 1, 1, 1, 21)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2153, 1, 1, 1, 22)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2154, 1, 1, 1, 23)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2155, 1, 1, 1, 24)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2156, 1, 1, 1, 25)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2157, 1, 1, 1, 26)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2158, 1, 1, 1, 27)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2159, 1, 1, 1, 28)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2160, 1, 1, 1, 29)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2161, 1, 1, 1, 30)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2162, 1, 1, 1, 31)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (1966, 1, 1, 3, 42)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2163, 1, 1, 1, 32)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2164, 1, 1, 1, 33)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2165, 1, 1, 1, 34)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2166, 1, 1, 1, 35)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2167, 1, 1, 1, 36)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2168, 1, 1, 1, 37)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2169, 1, 1, 1, 38)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2170, 1, 1, 1, 39)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2171, 1, 1, 1, 40)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2172, 1, 1, 1, 42)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2173, 1, 1, 1, 41)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2237, 1, 1, 1, 62)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2238, 1, 1, 1, 63)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2239, 1, 1, 1, 64)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2240, 1, 1, 1, 65)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2241, 1, 1, 1, 66)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2242, 1, 1, 1, 67)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2243, 1, 1, 1, 68)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2244, 1, 1, 1, 69)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2245, 1, 1, 1, 70)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2228, 1, 1, 1, 71)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2229, 1, 1, 1, 72)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2230, 1, 1, 1, 73)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2231, 1, 1, 1, 74)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2232, 1, 1, 1, 75)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2233, 1, 1, 1, 76)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2234, 1, 1, 1, 77)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2235, 1, 1, 1, 78)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2236, 1, 1, 1, 79)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2192, 1, 1, 1, 81)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2246, 1, 1, 1, 80)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2247, 1, 1, 1, 82)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2248, 1, 1, 1, 83)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2249, 1, 1, 1, 84)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2250, 1, 1, 1, 85)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2251, 1, 1, 1, 86)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2252, 1, 1, 1, 87)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2253, 1, 1, 1, 88)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2254, 1, 1, 1, 89)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2255, 1, 1, 1, 90)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2256, 1, 1, 1, 91)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2257, 1, 1, 1, 92)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2258, 1, 1, 1, 93)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2259, 1, 1, 1, 94)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2207, 1, 1, 1, 95)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2208, 1, 1, 1, 96)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2209, 1, 1, 1, 97)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2210, 1, 1, 1, 98)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2211, 1, 1, 1, 112)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2212, 1, 1, 1, 99)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2213, 1, 1, 1, 100)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2214, 1, 1, 1, 101)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2215, 1, 1, 1, 102)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2216, 1, 1, 1, 116)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2217, 1, 1, 1, 113)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2218, 1, 1, 1, 114)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2219, 1, 1, 1, 103)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2220, 1, 1, 1, 104)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2221, 1, 1, 1, 105)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2222, 1, 1, 1, 106)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2223, 1, 1, 1, 107)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2224, 1, 1, 1, 108)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2225, 1, 1, 1, 109)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2226, 1, 1, 1, 110)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2227, 0, 1, 1, 117)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (3228, 1, 0, 1, 118)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (3229, 0, 0, 3, 118)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (1955, 1, 1, 3, 1)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (1956, 1, 1, 3, 2)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (1957, 1, 1, 3, 3)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (1958, 1, 1, 3, 4)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (1959, 1, 1, 3, 5)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (1960, 1, 1, 3, 6)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (1961, 1, 1, 3, 7)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (1962, 1, 1, 3, 8)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (1963, 1, 1, 3, 9)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (1964, 1, 1, 3, 10)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (1965, 1, 1, 3, 41)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2057, 1, 1, 3, 21)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2058, 1, 1, 3, 22)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2059, 1, 1, 3, 23)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2060, 1, 1, 3, 24)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2061, 1, 1, 3, 25)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2062, 1, 1, 3, 26)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2063, 1, 1, 3, 27)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2064, 1, 1, 3, 28)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2065, 1, 1, 3, 29)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2066, 1, 1, 3, 30)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2067, 1, 1, 3, 31)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2068, 1, 1, 3, 32)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2069, 1, 1, 3, 33)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2070, 1, 1, 3, 34)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2071, 1, 1, 3, 35)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2072, 1, 1, 3, 36)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2073, 1, 1, 3, 37)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2074, 1, 1, 3, 38)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2075, 1, 1, 3, 39)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2076, 1, 1, 3, 40)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2086, 1, 1, 3, 71)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2087, 1, 1, 3, 72)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2088, 1, 1, 3, 73)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2089, 1, 1, 3, 74)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2090, 1, 1, 3, 75)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2091, 1, 1, 3, 76)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2092, 1, 1, 3, 77)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2093, 1, 1, 3, 78)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2094, 1, 1, 3, 79)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2096, 1, 1, 3, 80)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2097, 1, 1, 3, 82)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2098, 1, 1, 3, 83)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2099, 1, 1, 3, 84)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2100, 1, 1, 3, 85)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2101, 1, 1, 3, 86)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2102, 1, 1, 3, 87)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2103, 1, 1, 3, 88)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2104, 1, 1, 3, 89)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2105, 1, 1, 3, 90)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2106, 1, 1, 3, 91)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2107, 1, 1, 3, 92)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2108, 1, 1, 3, 93)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2109, 1, 1, 3, 94)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2130, 1, 1, 1, 11)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2131, 1, 1, 1, 12)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2132, 1, 1, 1, 13)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2133, 1, 1, 1, 14)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2134, 1, 1, 1, 15)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2135, 1, 1, 1, 16)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2136, 1, 1, 1, 17)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2137, 1, 1, 1, 18)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2138, 1, 1, 1, 19)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2139, 1, 1, 1, 20)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2140, 1, 1, 1, 1)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2141, 1, 1, 1, 2)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2142, 1, 1, 1, 3)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2143, 1, 1, 1, 4)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2144, 1, 1, 1, 5)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2145, 1, 1, 1, 6)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2146, 1, 1, 1, 7)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2147, 1, 1, 1, 8)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2148, 1, 1, 1, 9)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2149, 1, 1, 1, 10)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2027, 1, 1, 3, 11)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2028, 1, 1, 3, 12)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2029, 1, 1, 3, 13)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2030, 1, 1, 3, 14)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2031, 1, 1, 3, 15)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2032, 1, 1, 3, 16)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2033, 1, 1, 3, 17)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2034, 1, 1, 3, 18)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2035, 1, 1, 3, 19)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2036, 1, 1, 3, 20)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2077, 1, 1, 3, 62)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2078, 1, 1, 3, 63)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2079, 1, 1, 3, 64)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2080, 1, 1, 3, 65)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2081, 1, 1, 3, 66)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2082, 1, 1, 3, 67)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2083, 1, 1, 3, 68)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2084, 1, 1, 3, 69)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2085, 1, 1, 3, 70)
GO
INSERT [dbo].[gr_permission_properties] ([id], [read_right], [write_right], [group_id], [permission_property_id]) VALUES (2095, 1, 1, 3, 81)
GO
SET IDENTITY_INSERT [dbo].[gr_permission_properties] OFF
GO
INSERT [dbo].[gr_prekidi] ([datumPrekida]) VALUES (N'04.01.2023')
GO
INSERT [dbo].[gr_prekidi] ([datumPrekida]) VALUES (N'03.02.2023')
GO
INSERT [dbo].[gr_prekidi] ([datumPrekida]) VALUES (N'03.03.2023')
GO
INSERT [dbo].[gr_prekidi] ([datumPrekida]) VALUES (N'05.04.2023')
GO
INSERT [dbo].[gr_prekidi] ([datumPrekida]) VALUES (N'04.05.2023')
GO
INSERT [dbo].[gr_prekidi] ([datumPrekida]) VALUES (N'05.06.2023')
GO
INSERT [dbo].[gr_prekidi] ([datumPrekida]) VALUES (N'05.07.2023')
GO
INSERT [dbo].[gr_prekidi] ([datumPrekida]) VALUES (N'03.08.2023')
GO
INSERT [dbo].[gr_prekidi] ([datumPrekida]) VALUES (N'05.09.2023')
GO
INSERT [dbo].[gr_prekidi] ([datumPrekida]) VALUES (N'04.10.2023')
GO
INSERT [dbo].[gr_prekidi] ([datumPrekida]) VALUES (N'06.11.2023')
GO
INSERT [dbo].[gr_prekidi] ([datumPrekida]) VALUES (N'05.12.2023')
GO
INSERT [dbo].[gr_prekidi] ([datumPrekida]) VALUES (N'04.01.2023')
GO
INSERT [dbo].[gr_prekidi] ([datumPrekida]) VALUES (N'03.02.2023')
GO
INSERT [dbo].[gr_prekidi] ([datumPrekida]) VALUES (N'03.03.2023')
GO
INSERT [dbo].[gr_prekidi] ([datumPrekida]) VALUES (N'05.04.2023')
GO
INSERT [dbo].[gr_prekidi] ([datumPrekida]) VALUES (N'04.05.2023')
GO
INSERT [dbo].[gr_prekidi] ([datumPrekida]) VALUES (N'05.06.2023')
GO
INSERT [dbo].[gr_prekidi] ([datumPrekida]) VALUES (N'05.07.2023')
GO
INSERT [dbo].[gr_prekidi] ([datumPrekida]) VALUES (N'03.08.2023')
GO
INSERT [dbo].[gr_prekidi] ([datumPrekida]) VALUES (N'05.09.2023')
GO
INSERT [dbo].[gr_prekidi] ([datumPrekida]) VALUES (N'04.10.2023')
GO
INSERT [dbo].[gr_prekidi] ([datumPrekida]) VALUES (N'06.11.2023')
GO
INSERT [dbo].[gr_prekidi] ([datumPrekida]) VALUES (N'05.12.2023')
GO
SET IDENTITY_INSERT [dbo].[gr_property_lists] ON 
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (1, N'policy/Broj_Polise')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (2, N'policy/Broj_Ponude')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (3, N'policy/Pol_kreis')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (4, N'policy/Bransa')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (5, N'policy/Naziv_Branse')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (6, N'policy/Pocetak_osiguranja')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (7, N'policy/Istek_osiguranja')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (8, N'policy/Datum_storna')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (9, N'policy/Ugovarac')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (10, N'policy/Osiguranik')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (11, N'clientHistory')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (12, N'clientAnalyticalInfo/client/klijent_bruto_polisirana_premija')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (13, N'clientAnalyticalInfo/client/klijent_neto_polisirana_premija')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (14, N'clientAnalyticalInfo/client/klijent_ukupna_potrazivanja')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (15, N'clientAnalyticalInfo/client/dani_kasnjenja')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (16, N'clientAnalyticalInfo/client/klijent_dospjela_potrazivanja')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (17, N'excelPath')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (18, N'pdfPath')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (19, N'datum_dokumenta')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (20, N'broj_dokumenta')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (21, N'broj_ponude')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (22, N'vid')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (23, N'opis_knjizenja')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (24, N'duguje')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (25, N'potrazuje')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (26, N'saldo')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (27, N'Broj_Polise')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (28, N'Broj_Ponude')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (29, N'Pol_kreis')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (30, N'Bransa')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (31, N'Naziv_Branse')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (32, N'Pocetak_osiguranja')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (33, N'Istek_osiguranja')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (34, N'Datum_storna')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (35, N'Storno_tip')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (36, N'StatusPolise')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (37, N'Nacin_Placanja')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (38, N'Bruto_polisirana_premija')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (39, N'Neto_polisirana_premija')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (40, N'Premija')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (41, N'Sifra_zastupnika')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (42, N'Naziv_zastupnika')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (43, N'Kanal_prodaje')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (44, N'Dani_Kasnjenja')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (45, N'Ugovarac')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (46, N'Osiguranik')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (47, N'excelBuffer')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (48, N'pdfBuffer')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (49, N'datum_dokumenta')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (50, N'polisa')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (51, N'broj_dokumenta')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (52, N'broj_ponude')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (53, N'vid')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (54, N'opis_knjizenja')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (55, N'duguje')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (56, N'potrazuje')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (57, N'saldo')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (58, N'klijent')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (59, N'datum_rodjenja')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (60, N'jmbg_pib')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (61, N'adresa')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (62, N'mjesto')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (63, N'telefon1')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (64, N'telefon2')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (65, N'email')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (66, N'policies')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (67, N'pdfBuffer')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (68, N'excelBuffer')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (69, N'klijent_bruto_polisirana_premija')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (70, N'klijent_neto_polisirana_premija')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (71, N'dani_kasnjenja')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (72, N'klijent_ukupna_potrazivanja')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (73, N'klijent_dospjela_potrazivanja')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (74, N'broj_polise')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (75, N'Naziv_Branse')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (76, N'Nacin_Placanja')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (77, N'Bruto_polisirana_premija')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (78, N'Neto_polisirana_premija')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (79, N'Dani_Kasnjenja')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (80, N'ukupna_potrazivanja')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (81, N'dospjela_potrazivanja')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (82, N'id_greske')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (83, N'polisa')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (84, N'opis_greske')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (85, N'datum_greske')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (86, N'polisa')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (87, N'id_greske')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (88, N'komentar')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (89, N'datum_komentara')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (91, N'Potrazivanje Naplata')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (92, N'Potrazivanje Klijenta')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (93, N'Kanal Prodaje')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (94, N'Dani Kasnjenja Polisa')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (95, N'Provizije')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (96, N'Provjera Gresaka')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (97, N'Polisirane Premije')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (102, N'Rezertvisane stete')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (99, N'username')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (100, N'Polisirane Premije')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (103, N'test')
GO
INSERT [dbo].[gr_property_lists] ([id], [property_path]) VALUES (104, N'10seconds')
GO
SET IDENTITY_INSERT [dbo].[gr_property_lists] OFF
GO
SET IDENTITY_INSERT [dbo].[reports] ON 
GO
INSERT [dbo].[reports] ([id], [report_name], [procedure_id]) VALUES (13, N'Potrazivanje Naplata', 884198200)
GO
INSERT [dbo].[reports] ([id], [report_name], [procedure_id]) VALUES (14, N'Potrazivanje Klijenta', 868198143)
GO
INSERT [dbo].[reports] ([id], [report_name], [procedure_id]) VALUES (15, N'Kanal Prodaje', 836198029)
GO
INSERT [dbo].[reports] ([id], [report_name], [procedure_id]) VALUES (16, N'Dani Kasnjenja Polisa', 724197630)
GO
INSERT [dbo].[reports] ([id], [report_name], [procedure_id]) VALUES (17, N'Provizije', 1028198713)
GO
INSERT [dbo].[reports] ([id], [report_name], [procedure_id]) VALUES (18, N'Polisirane Premije', 1076198884)
GO
INSERT [dbo].[reports] ([id], [report_name], [procedure_id]) VALUES (19, N'Provjera Gresaka', 916198314)
GO
INSERT [dbo].[reports] ([id], [report_name], [procedure_id]) VALUES (21, N'Rezertvisane stete', 985770569)
GO
INSERT [dbo].[reports] ([id], [report_name], [procedure_id]) VALUES (22, N'test', 1305771709)
GO
INSERT [dbo].[reports] ([id], [report_name], [procedure_id]) VALUES (23, N'10seconds', 790293875)
GO
SET IDENTITY_INSERT [dbo].[reports] OFF
GO
SET IDENTITY_INSERT [dbo].[reports_param_options] ON 
GO
INSERT [dbo].[reports_param_options] ([id], [procedure_id], [report_id], [order_param], [param_name], [sql]) VALUES (18, 1028198713, 17, 1, N'@datumod', N'')
GO
INSERT [dbo].[reports_param_options] ([id], [procedure_id], [report_id], [order_param], [param_name], [sql]) VALUES (19, 1028198713, 17, 2, N'@datumdo', N'')
GO
INSERT [dbo].[reports_param_options] ([id], [procedure_id], [report_id], [order_param], [param_name], [sql]) VALUES (20, 1028198713, 17, 3, N'@Polisa', N'select top 10 bra_obnr from branche (nolock)')
GO
INSERT [dbo].[reports_param_options] ([id], [procedure_id], [report_id], [order_param], [param_name], [sql]) VALUES (21, 985770569, 21, NULL, NULL, N'')
GO
INSERT [dbo].[reports_param_options] ([id], [procedure_id], [report_id], [order_param], [param_name], [sql]) VALUES (22, 836198029, 15, 1, N'@datum', N'')
GO
INSERT [dbo].[reports_param_options] ([id], [procedure_id], [report_id], [order_param], [param_name], [sql]) VALUES (23, 836198029, 15, 2, N'@KanalProdaje', N'select bra_obnr as polisa, ''opis'' as opis from branche (nolock)')
GO
INSERT [dbo].[reports_param_options] ([id], [procedure_id], [report_id], [order_param], [param_name], [sql]) VALUES (24, 1305771709, 22, 1, N'@datum', N'')
GO
INSERT [dbo].[reports_param_options] ([id], [procedure_id], [report_id], [order_param], [param_name], [sql]) VALUES (25, 790293875, 23, 1, N'@TEST', N'')
GO
SET IDENTITY_INSERT [dbo].[reports_param_options] OFF

SET IDENTITY_INSERT [dbo].[users] ON 
GO
INSERT [dbo].[users] ([ID], [username], [name], [last_Name], [date_of_birth], [role], [password], [email], [verified], [time_to_varify], [created_at], [updated_at], [email_verification_token]) VALUES (1, N'filip123', N'Filip', N'Stankovic', N'11.01.1999', NULL, N'$2a$12$q81bNn7anzIoclJKaRtzlODlLN0rzMId4MUwgiZJDK/khLZx9TGQW', N'filips385@rocketmail.com', 1, CAST(N'2023-07-03T09:18:00.000' AS DateTime), CAST(N'2023-07-03T09:08:00.000' AS DateTime), NULL, N'310357169')
GO
INSERT [dbo].[users] ([ID], [username], [name], [last_Name], [date_of_birth], [role], [password], [email], [verified], [time_to_varify], [created_at], [updated_at], [email_verification_token]) VALUES (17, N'ILINCICM', N'Maja', N'Ilincic', NULL, NULL, N'$2a$12$q81bNn7anzIoclJKaRtzlODlLN0rzMId4MUwgiZJDK/khLZx9TGQW', N'Maja.Ilincic@grawe.me', 1, CAST(N'2024-07-24T10:11:57.960' AS DateTime), CAST(N'2024-07-24T10:01:57.960' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[users] ([ID], [username], [name], [last_Name], [date_of_birth], [role], [password], [email], [verified], [time_to_varify], [created_at], [updated_at], [email_verification_token]) VALUES (6, N'loncars', N'Sanja', N'Loncar', N'01.01.1998', NULL, N'$2a$12$q81bNn7anzIoclJKaRtzlODlLN0rzMId4MUwgiZJDK/khLZx9TGQW', N'sanja.loncar@grawe.me', 1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[users] ([ID], [username], [name], [last_Name], [date_of_birth], [role], [password], [email], [verified], [time_to_varify], [created_at], [updated_at], [email_verification_token]) VALUES (18, N'CORSOVIT', N'Tijana', N'Pantovic', NULL, NULL, N'$2a$12$q81bNn7anzIoclJKaRtzlODlLN0rzMId4MUwgiZJDK/khLZx9TGQW', N'Tijana.Corsovic@grawe.me', 1, CAST(N'2024-07-24T12:22:21.803' AS DateTime), CAST(N'2024-07-24T12:12:21.803' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[users] ([ID], [username], [name], [last_Name], [date_of_birth], [role], [password], [email], [verified], [time_to_varify], [created_at], [updated_at], [email_verification_token]) VALUES (19, N'BESOVICM', N'Maja', N'Besovic', NULL, NULL, N'$2a$12$q81bNn7anzIoclJKaRtzlODlLN0rzMId4MUwgiZJDK/khLZx9TGQW', N'Maja.Besovic@grawe.me', 1, CAST(N'2024-07-31T12:11:29.953' AS DateTime), CAST(N'2024-07-31T12:01:29.953' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[users] ([ID], [username], [name], [last_Name], [date_of_birth], [role], [password], [email], [verified], [time_to_varify], [created_at], [updated_at], [email_verification_token]) VALUES (20, N'ZAJOVICM', N'Milica', N'Zajovic', NULL, NULL, N'$2a$12$q81bNn7anzIoclJKaRtzlODlLN0rzMId4MUwgiZJDK/khLZx9TGQW', N'Milica.Zajovic@grawe.me', 1, CAST(N'2024-08-02T10:29:32.003' AS DateTime), CAST(N'2024-08-02T10:19:32.003' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[users] ([ID], [username], [name], [last_Name], [date_of_birth], [role], [password], [email], [verified], [time_to_varify], [created_at], [updated_at], [email_verification_token]) VALUES (14, N'STANKOFI', N'Filip', N'Stankovic', NULL, NULL, N'$2a$12$q81bNn7anzIoclJKaRtzlODlLN0rzMId4MUwgiZJDK/khLZx9TGQW', N'filips385@rocketmail.com', 1, CAST(N'2024-07-09T14:54:32.533' AS DateTime), CAST(N'2024-07-09T14:44:32.533' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[users] ([ID], [username], [name], [last_Name], [date_of_birth], [role], [password], [email], [verified], [time_to_varify], [created_at], [updated_at], [email_verification_token]) VALUES (15, N'VUJOSEVP', N'Petar', N'Vujosevic', NULL, NULL, N'$2a$12$q81bNn7anzIoclJKaRtzlODlLN0rzMId4MUwgiZJDK/khLZx9TGQW', N'Petar.Vujosevic@grawe.me', 1, CAST(N'2024-07-16T13:54:51.960' AS DateTime), CAST(N'2024-07-16T13:44:51.960' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[users] ([ID], [username], [name], [last_Name], [date_of_birth], [role], [password], [email], [verified], [time_to_varify], [created_at], [updated_at], [email_verification_token]) VALUES (16, N'LEROI', N'Ivan', N'Lero', NULL, NULL, N'$2a$12$q81bNn7anzIoclJKaRtzlODlLN0rzMId4MUwgiZJDK/khLZx9TGQW', N'Ivan.Lero@grawe.me', 1, CAST(N'2024-07-23T10:24:11.117' AS DateTime), CAST(N'2024-07-23T10:14:11.117' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[users] ([ID], [username], [name], [last_Name], [date_of_birth], [role], [password], [email], [verified], [time_to_varify], [created_at], [updated_at], [email_verification_token]) VALUES (21, N'testuser123', N'Test', N'User', N'2024.10.06', NULL, N'$2a$12$q81bNn7anzIoclJKaRtzlODlLN0rzMId4MUwgiZJDK/khLZx9TGQW', N'test@gmail.com', 1, CAST(N'2024-10-06T13:09:19.660' AS DateTime), CAST(N'2024-10-06T12:59:19.660' AS DateTime), NULL, N'244260086')
GO
SET IDENTITY_INSERT [dbo].[users] OFF
GO
