--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

--// Library & Remotes
local Library = require(ReplicatedStorage:WaitForChild("Library"))
local BankDeposit = ReplicatedStorage:WaitForChild("Bank Deposit")
local BankWithdraw = ReplicatedStorage:WaitForChild("Bank Withdraw")

--// Save table for deposited pets
local DepositedPets = {["Exclusive Lucky Egg"]={"ide3c0939d2552416982a843dbcb72516f","idb77d0d4dc181487faa9f410f198e3c24","id11de4ad5cef14244b2d3d82cf2d6b993","idf2459fa8577949b085bae5a46825789c","id92fd051272fb4da582fd2d5351f0f411","id6ef5794c9583415c8eaf94610a1a3cca","id523ba86383d54d678053de1d6ffbeeac","id4383658d319b4f3d80ce287bec2c4b9b","ide3fc75c74a8c44d6b0c68f19ec50526f","id508729e6b18342398686e7724a1eaf03","ided00e3bf0d34456688388f9e58b64112","id90edbaa9dffb456392b95ef87d0b0d32","id2dcfbcbc8e7a47d6af04f10ac39c992c","id92ad00f8bd0e485584929f57fb008fc4","id8f200df77a1e4456a07302d6092c2bac","id7b1341463cf247cbb04fe65be72a4d1e","id1cd8912a18284f448c5eab164df64ec8","idd708295e4779489dbbe37d918d61395e","idf2264b33e5524162b84d4e531447a433","id703fe88d15884940a863e6a41acbe9fa","idb9a7fdf9f7a34048bcac92b7545af7f2","idcb19c2f8f97e4406b154fdaddff1c0e7","idf0487179800a48e69a53d76d39d496a7","idbfba767ca57740ccbc0594f54b32d86f","ida00bb888fb734cc29879a555ed898ea1","id219576b33f4e443e8d6f1e1ec6efcc54","id58f6b679014849fd9c8c24a742239e1a","idfd16f0a8f35047a0b8b50e165fe5867f","id36791c49f5a9432398fdaa8dfa7c00a0","id2d6f7fd834ee4b5a8a0a7a8d130f77e0","ida91b422b9b2b4ca58e01e11b183b014e","idc829f002c1924647bf1998de8982c9ca","id39f73afd4b4b45aaa35025fc5e340d9d","idcf2482af750a42369a49d487d1b544e3","id14fdae624c124fad8dd4e6833dbf9054","id708712b6edd5405faa091cb5f9bd3f5e","idec63b5a82b7142329f0d1fd4f83e5c91","idbed9ec4631c6452e979c13aff3990129","id6d9709d185f04ef1ad92b368e68a0b1e","id90a165315dc04c4493aa8b98c379a472","ide3c0939d2552416982a843dbcb72516f","idb77d0d4dc181487faa9f410f198e3c24","ided00e3bf0d34456688388f9e58b64112","id90edbaa9dffb456392b95ef87d0b0d32","id11de4ad5cef14244b2d3d82cf2d6b993","idf2459fa8577949b085bae5a46825789c","id92fd051272fb4da582fd2d5351f0f411","id6ef5794c9583415c8eaf94610a1a3cca","id36791c49f5a9432398fdaa8dfa7c00a0","id4383658d319b4f3d80ce287bec2c4b9b","ide3fc75c74a8c44d6b0c68f19ec50526f","ida91b422b9b2b4ca58e01e11b183b014e","idc829f002c1924647bf1998de8982c9ca","id2dcfbcbc8e7a47d6af04f10ac39c992c","id92ad00f8bd0e485584929f57fb008fc4","id8f200df77a1e4456a07302d6092c2bac","id39f73afd4b4b45aaa35025fc5e340d9d","id7b1341463cf247cbb04fe65be72a4d1e","id1cd8912a18284f448c5eab164df64ec8","idd708295e4779489dbbe37d918d61395e","idf2264b33e5524162b84d4e531447a433","id703fe88d15884940a863e6a41acbe9fa","idb9a7fdf9f7a34048bcac92b7545af7f2","idcb19c2f8f97e4406b154fdaddff1c0e7","idcf2482af750a42369a49d487d1b544e3","idf0487179800a48e69a53d76d39d496a7","idbed9ec4631c6452e979c13aff3990129","ida00bb888fb734cc29879a555ed898ea1","id219576b33f4e443e8d6f1e1ec6efcc54","idfd16f0a8f35047a0b8b50e165fe5867f","id523ba86383d54d678053de1d6ffbeeac","id2d6f7fd834ee4b5a8a0a7a8d130f77e0","id508729e6b18342398686e7724a1eaf03","id14fdae624c124fad8dd4e6833dbf9054","idbfba767ca57740ccbc0594f54b32d86f","id708712b6edd5405faa091cb5f9bd3f5e","idec63b5a82b7142329f0d1fd4f83e5c91","id6d9709d185f04ef1ad92b368e68a0b1e","id90a165315dc04c4493aa8b98c379a472","id58f6b679014849fd9c8c24a742239e1a","ide3c0939d2552416982a843dbcb72516f","ided00e3bf0d34456688388f9e58b64112","idb77d0d4dc181487faa9f410f198e3c24","id92fd051272fb4da582fd2d5351f0f411","id4383658d319b4f3d80ce287bec2c4b9b","ide3fc75c74a8c44d6b0c68f19ec50526f","id90edbaa9dffb456392b95ef87d0b0d32","id92ad00f8bd0e485584929f57fb008fc4","id1cd8912a18284f448c5eab164df64ec8","idd708295e4779489dbbe37d918d61395e","idf2264b33e5524162b84d4e531447a433","id703fe88d15884940a863e6a41acbe9fa","id11de4ad5cef14244b2d3d82cf2d6b993","idf2459fa8577949b085bae5a46825789c","id6ef5794c9583415c8eaf94610a1a3cca","id2dcfbcbc8e7a47d6af04f10ac39c992c","id8f200df77a1e4456a07302d6092c2bac","id7b1341463cf247cbb04fe65be72a4d1e","idb9a7fdf9f7a34048bcac92b7545af7f2","idcb19c2f8f97e4406b154fdaddff1c0e7","idf0487179800a48e69a53d76d39d496a7","ida00bb888fb734cc29879a555ed898ea1","id219576b33f4e443e8d6f1e1ec6efcc54","idfd16f0a8f35047a0b8b50e165fe5867f","id523ba86383d54d678053de1d6ffbeeac","id36791c49f5a9432398fdaa8dfa7c00a0","id508729e6b18342398686e7724a1eaf03","ida91b422b9b2b4ca58e01e11b183b014e","idc829f002c1924647bf1998de8982c9ca","id39f73afd4b4b45aaa35025fc5e340d9d","idcf2482af750a42369a49d487d1b544e3","idbfba767ca57740ccbc0594f54b32d86f","idbed9ec4631c6452e979c13aff3990129","id6d9709d185f04ef1ad92b368e68a0b1e","id58f6b679014849fd9c8c24a742239e1a","id2d6f7fd834ee4b5a8a0a7a8d130f77e0","id14fdae624c124fad8dd4e6833dbf9054","id708712b6edd5405faa091cb5f9bd3f5e","idec63b5a82b7142329f0d1fd4f83e5c91","id90a165315dc04c4493aa8b98c379a472","ide3c0939d2552416982a843dbcb72516f","idb77d0d4dc181487faa9f410f198e3c24","ided00e3bf0d34456688388f9e58b64112","id90edbaa9dffb456392b95ef87d0b0d32","id11de4ad5cef14244b2d3d82cf2d6b993","idf2459fa8577949b085bae5a46825789c","id92fd051272fb4da582fd2d5351f0f411","id4383658d319b4f3d80ce287bec2c4b9b","ide3fc75c74a8c44d6b0c68f19ec50526f","id2dcfbcbc8e7a47d6af04f10ac39c992c","id92ad00f8bd0e485584929f57fb008fc4","id1cd8912a18284f448c5eab164df64ec8","idd708295e4779489dbbe37d918d61395e","idf2264b33e5524162b84d4e531447a433","id703fe88d15884940a863e6a41acbe9fa","idb9a7fdf9f7a34048bcac92b7545af7f2","idcb19c2f8f97e4406b154fdaddff1c0e7","idf0487179800a48e69a53d76d39d496a7","ida00bb888fb734cc29879a555ed898ea1","id219576b33f4e443e8d6f1e1ec6efcc54","id6ef5794c9583415c8eaf94610a1a3cca","id523ba86383d54d678053de1d6ffbeeac","id36791c49f5a9432398fdaa8dfa7c00a0","id2d6f7fd834ee4b5a8a0a7a8d130f77e0","id508729e6b18342398686e7724a1eaf03","ida91b422b9b2b4ca58e01e11b183b014e","idc829f002c1924647bf1998de8982c9ca","id8f200df77a1e4456a07302d6092c2bac","id39f73afd4b4b45aaa35025fc5e340d9d","id7b1341463cf247cbb04fe65be72a4d1e","idcf2482af750a42369a49d487d1b544e3","id14fdae624c124fad8dd4e6833dbf9054","idbfba767ca57740ccbc0594f54b32d86f","id708712b6edd5405faa091cb5f9bd3f5e","idec63b5a82b7142329f0d1fd4f83e5c91","idbed9ec4631c6452e979c13aff3990129","id6d9709d185f04ef1ad92b368e68a0b1e","id90a165315dc04c4493aa8b98c379a472","id58f6b679014849fd9c8c24a742239e1a","idfd16f0a8f35047a0b8b50e165fe5867f","ide3c0939d2552416982a843dbcb72516f","idb77d0d4dc181487faa9f410f198e3c24","ided00e3bf0d34456688388f9e58b64112","id90edbaa9dffb456392b95ef87d0b0d32","idf2459fa8577949b085bae5a46825789c","id92fd051272fb4da582fd2d5351f0f411","id4383658d319b4f3d80ce287bec2c4b9b","ide3fc75c74a8c44d6b0c68f19ec50526f","id92ad00f8bd0e485584929f57fb008fc4","id1cd8912a18284f448c5eab164df64ec8","idd708295e4779489dbbe37d918d61395e","idf2264b33e5524162b84d4e531447a433","id703fe88d15884940a863e6a41acbe9fa","idcb19c2f8f97e4406b154fdaddff1c0e7","ida00bb888fb734cc29879a555ed898ea1","id11de4ad5cef14244b2d3d82cf2d6b993","id6ef5794c9583415c8eaf94610a1a3cca","id523ba86383d54d678053de1d6ffbeeac","id36791c49f5a9432398fdaa8dfa7c00a0","id2d6f7fd834ee4b5a8a0a7a8d130f77e0","id508729e6b18342398686e7724a1eaf03","ida91b422b9b2b4ca58e01e11b183b014e","idc829f002c1924647bf1998de8982c9ca","id2dcfbcbc8e7a47d6af04f10ac39c992c","id8f200df77a1e4456a07302d6092c2bac","id39f73afd4b4b45aaa35025fc5e340d9d","id7b1341463cf247cbb04fe65be72a4d1e","idb9a7fdf9f7a34048bcac92b7545af7f2","idcf2482af750a42369a49d487d1b544e3","idf0487179800a48e69a53d76d39d496a7","id14fdae624c124fad8dd4e6833dbf9054","idbfba767ca57740ccbc0594f54b32d86f","id708712b6edd5405faa091cb5f9bd3f5e","idec63b5a82b7142329f0d1fd4f83e5c91","idbed9ec4631c6452e979c13aff3990129","id6d9709d185f04ef1ad92b368e68a0b1e","id90a165315dc04c4493aa8b98c379a472","id219576b33f4e443e8d6f1e1ec6efcc54","id58f6b679014849fd9c8c24a742239e1a","idfd16f0a8f35047a0b8b50e165fe5867f","ide3c0939d2552416982a843dbcb72516f","idb77d0d4dc181487faa9f410f198e3c24","ided00e3bf0d34456688388f9e58b64112","id90edbaa9dffb456392b95ef87d0b0d32","id92fd051272fb4da582fd2d5351f0f411","id4383658d319b4f3d80ce287bec2c4b9b","ide3fc75c74a8c44d6b0c68f19ec50526f","id92ad00f8bd0e485584929f57fb008fc4","id1cd8912a18284f448c5eab164df64ec8","idd708295e4779489dbbe37d918d61395e","idf2264b33e5524162b84d4e531447a433","id703fe88d15884940a863e6a41acbe9fa","id11de4ad5cef14244b2d3d82cf2d6b993","idf2459fa8577949b085bae5a46825789c","id6ef5794c9583415c8eaf94610a1a3cca","id523ba86383d54d678053de1d6ffbeeac","id36791c49f5a9432398fdaa8dfa7c00a0","id2d6f7fd834ee4b5a8a0a7a8d130f77e0","id508729e6b18342398686e7724a1eaf03","ida91b422b9b2b4ca58e01e11b183b014e","idc829f002c1924647bf1998de8982c9ca","id2dcfbcbc8e7a47d6af04f10ac39c992c","id8f200df77a1e4456a07302d6092c2bac","id39f73afd4b4b45aaa35025fc5e340d9d","id7b1341463cf247cbb04fe65be72a4d1e","idb9a7fdf9f7a34048bcac92b7545af7f2","idcb19c2f8f97e4406b154fdaddff1c0e7","idcf2482af750a42369a49d487d1b544e3","idf0487179800a48e69a53d76d39d496a7","id14fdae624c124fad8dd4e6833dbf9054","idbfba767ca57740ccbc0594f54b32d86f","id708712b6edd5405faa091cb5f9bd3f5e","idec63b5a82b7142329f0d1fd4f83e5c91","idbed9ec4631c6452e979c13aff3990129","id6d9709d185f04ef1ad92b368e68a0b1e","ida00bb888fb734cc29879a555ed898ea1","id90a165315dc04c4493aa8b98c379a472","id219576b33f4e443e8d6f1e1ec6efcc54","id58f6b679014849fd9c8c24a742239e1a","idfd16f0a8f35047a0b8b50e165fe5867f","ide3c0939d2552416982a843dbcb72516f","id11de4ad5cef14244b2d3d82cf2d6b993","idb77d0d4dc181487faa9f410f198e3c24","idf2459fa8577949b085bae5a46825789c","id92fd051272fb4da582fd2d5351f0f411","id4383658d319b4f3d80ce287bec2c4b9b","ide3fc75c74a8c44d6b0c68f19ec50526f","ided00e3bf0d34456688388f9e58b64112","id90edbaa9dffb456392b95ef87d0b0d32","id2dcfbcbc8e7a47d6af04f10ac39c992c","id92ad00f8bd0e485584929f57fb008fc4","id1cd8912a18284f448c5eab164df64ec8","idd708295e4779489dbbe37d918d61395e","idf2264b33e5524162b84d4e531447a433","id703fe88d15884940a863e6a41acbe9fa","idb9a7fdf9f7a34048bcac92b7545af7f2","idcb19c2f8f97e4406b154fdaddff1c0e7","idf0487179800a48e69a53d76d39d496a7","ida00bb888fb734cc29879a555ed898ea1","id219576b33f4e443e8d6f1e1ec6efcc54","id6ef5794c9583415c8eaf94610a1a3cca","id523ba86383d54d678053de1d6ffbeeac","id36791c49f5a9432398fdaa8dfa7c00a0","id2d6f7fd834ee4b5a8a0a7a8d130f77e0","id508729e6b18342398686e7724a1eaf03","ida91b422b9b2b4ca58e01e11b183b014e","idc829f002c1924647bf1998de8982c9ca","id8f200df77a1e4456a07302d6092c2bac","id39f73afd4b4b45aaa35025fc5e340d9d","id7b1341463cf247cbb04fe65be72a4d1e","idcf2482af750a42369a49d487d1b544e3","id14fdae624c124fad8dd4e6833dbf9054","idbfba767ca57740ccbc0594f54b32d86f","id708712b6edd5405faa091cb5f9bd3f5e","idec63b5a82b7142329f0d1fd4f83e5c91","idbed9ec4631c6452e979c13aff3990129","id6d9709d185f04ef1ad92b368e68a0b1e","id90a165315dc04c4493aa8b98c379a472","id58f6b679014849fd9c8c24a742239e1a","idfd16f0a8f35047a0b8b50e165fe5867f","ide3c0939d2552416982a843dbcb72516f","ided00e3bf0d34456688388f9e58b64112","idb77d0d4dc181487faa9f410f198e3c24","id4383658d319b4f3d80ce287bec2c4b9b","ide3fc75c74a8c44d6b0c68f19ec50526f","id90edbaa9dffb456392b95ef87d0b0d32","id1cd8912a18284f448c5eab164df64ec8","idd708295e4779489dbbe37d918d61395e","idf2264b33e5524162b84d4e531447a433","id11de4ad5cef14244b2d3d82cf2d6b993","idf2459fa8577949b085bae5a46825789c","id92fd051272fb4da582fd2d5351f0f411","id6ef5794c9583415c8eaf94610a1a3cca","id523ba86383d54d678053de1d6ffbeeac","id36791c49f5a9432398fdaa8dfa7c00a0","id508729e6b18342398686e7724a1eaf03","ida91b422b9b2b4ca58e01e11b183b014e","idc829f002c1924647bf1998de8982c9ca","id2dcfbcbc8e7a47d6af04f10ac39c992c","id92ad00f8bd0e485584929f57fb008fc4","id8f200df77a1e4456a07302d6092c2bac","id39f73afd4b4b45aaa35025fc5e340d9d","id7b1341463cf247cbb04fe65be72a4d1e","id703fe88d15884940a863e6a41acbe9fa","idb9a7fdf9f7a34048bcac92b7545af7f2","idcb19c2f8f97e4406b154fdaddff1c0e7","idcf2482af750a42369a49d487d1b544e3","idf0487179800a48e69a53d76d39d496a7","idbfba767ca57740ccbc0594f54b32d86f","idbed9ec4631c6452e979c13aff3990129","id6d9709d185f04ef1ad92b368e68a0b1e","ida00bb888fb734cc29879a555ed898ea1","id219576b33f4e443e8d6f1e1ec6efcc54","id58f6b679014849fd9c8c24a742239e1a","idfd16f0a8f35047a0b8b50e165fe5867f","id2d6f7fd834ee4b5a8a0a7a8d130f77e0","id14fdae624c124fad8dd4e6833dbf9054","id708712b6edd5405faa091cb5f9bd3f5e","idec63b5a82b7142329f0d1fd4f83e5c91","id90a165315dc04c4493aa8b98c379a472","ide3c0939d2552416982a843dbcb72516f","idb77d0d4dc181487faa9f410f198e3c24","id92fd051272fb4da582fd2d5351f0f411","id4383658d319b4f3d80ce287bec2c4b9b","ide3fc75c74a8c44d6b0c68f19ec50526f","ided00e3bf0d34456688388f9e58b64112","id90edbaa9dffb456392b95ef87d0b0d32","id92ad00f8bd0e485584929f57fb008fc4","id1cd8912a18284f448c5eab164df64ec8","idd708295e4779489dbbe37d918d61395e","idf2264b33e5524162b84d4e531447a433","id703fe88d15884940a863e6a41acbe9fa","id11de4ad5cef14244b2d3d82cf2d6b993","idf2459fa8577949b085bae5a46825789c","id6ef5794c9583415c8eaf94610a1a3cca","id523ba86383d54d678053de1d6ffbeeac","id36791c49f5a9432398fdaa8dfa7c00a0","id2d6f7fd834ee4b5a8a0a7a8d130f77e0","id508729e6b18342398686e7724a1eaf03","ida91b422b9b2b4ca58e01e11b183b014e","idc829f002c1924647bf1998de8982c9ca","id2dcfbcbc8e7a47d6af04f10ac39c992c","id8f200df77a1e4456a07302d6092c2bac","id39f73afd4b4b45aaa35025fc5e340d9d","id7b1341463cf247cbb04fe65be72a4d1e","idb9a7fdf9f7a34048bcac92b7545af7f2","idcb19c2f8f97e4406b154fdaddff1c0e7","idcf2482af750a42369a49d487d1b544e3","idf0487179800a48e69a53d76d39d496a7","id14fdae624c124fad8dd4e6833dbf9054","idbfba767ca57740ccbc0594f54b32d86f","id708712b6edd5405faa091cb5f9bd3f5e","idec63b5a82b7142329f0d1fd4f83e5c91","idbed9ec4631c6452e979c13aff3990129","id6d9709d185f04ef1ad92b368e68a0b1e","ida00bb888fb734cc29879a555ed898ea1","id90a165315dc04c4493aa8b98c379a472","id219576b33f4e443e8d6f1e1ec6efcc54","id58f6b679014849fd9c8c24a742239e1a","idfd16f0a8f35047a0b8b50e165fe5867f","ide3c0939d2552416982a843dbcb72516f","idb77d0d4dc181487faa9f410f198e3c24","id4383658d319b4f3d80ce287bec2c4b9b","ide3fc75c74a8c44d6b0c68f19ec50526f","ided00e3bf0d34456688388f9e58b64112","id90edbaa9dffb456392b95ef87d0b0d32","id1cd8912a18284f448c5eab164df64ec8","idd708295e4779489dbbe37d918d61395e","idf2264b33e5524162b84d4e531447a433","id11de4ad5cef14244b2d3d82cf2d6b993","idf2459fa8577949b085bae5a46825789c","id92fd051272fb4da582fd2d5351f0f411","id6ef5794c9583415c8eaf94610a1a3cca","id523ba86383d54d678053de1d6ffbeeac","id36791c49f5a9432398fdaa8dfa7c00a0","id2d6f7fd834ee4b5a8a0a7a8d130f77e0","id508729e6b18342398686e7724a1eaf03","ida91b422b9b2b4ca58e01e11b183b014e","idc829f002c1924647bf1998de8982c9ca","id2dcfbcbc8e7a47d6af04f10ac39c992c","id92ad00f8bd0e485584929f57fb008fc4","id8f200df77a1e4456a07302d6092c2bac","id39f73afd4b4b45aaa35025fc5e340d9d","id7b1341463cf247cbb04fe65be72a4d1e","id703fe88d15884940a863e6a41acbe9fa","idb9a7fdf9f7a34048bcac92b7545af7f2","idcb19c2f8f97e4406b154fdaddff1c0e7","idcf2482af750a42369a49d487d1b544e3","idf0487179800a48e69a53d76d39d496a7","id14fdae624c124fad8dd4e6833dbf9054","idbfba767ca57740ccbc0594f54b32d86f","id708712b6edd5405faa091cb5f9bd3f5e","idec63b5a82b7142329f0d1fd4f83e5c91","idbed9ec4631c6452e979c13aff3990129","id6d9709d185f04ef1ad92b368e68a0b1e","ida00bb888fb734cc29879a555ed898ea1","id90a165315dc04c4493aa8b98c379a472","id219576b33f4e443e8d6f1e1ec6efcc54","id58f6b679014849fd9c8c24a742239e1a","idfd16f0a8f35047a0b8b50e165fe5867f","ide3c0939d2552416982a843dbcb72516f","idb77d0d4dc181487faa9f410f198e3c24","ided00e3bf0d34456688388f9e58b64112","id90edbaa9dffb456392b95ef87d0b0d32","id11de4ad5cef14244b2d3d82cf2d6b993","idf2459fa8577949b085bae5a46825789c","id92fd051272fb4da582fd2d5351f0f411","id4383658d319b4f3d80ce287bec2c4b9b","ide3fc75c74a8c44d6b0c68f19ec50526f","id2dcfbcbc8e7a47d6af04f10ac39c992c","id92ad00f8bd0e485584929f57fb008fc4","id1cd8912a18284f448c5eab164df64ec8","idd708295e4779489dbbe37d918d61395e","idf2264b33e5524162b84d4e531447a433","id703fe88d15884940a863e6a41acbe9fa","idb9a7fdf9f7a34048bcac92b7545af7f2","idcb19c2f8f97e4406b154fdaddff1c0e7","idf0487179800a48e69a53d76d39d496a7","ida00bb888fb734cc29879a555ed898ea1","id219576b33f4e443e8d6f1e1ec6efcc54","id6ef5794c9583415c8eaf94610a1a3cca","id523ba86383d54d678053de1d6ffbeeac","id36791c49f5a9432398fdaa8dfa7c00a0","id2d6f7fd834ee4b5a8a0a7a8d130f77e0","id508729e6b18342398686e7724a1eaf03","ida91b422b9b2b4ca58e01e11b183b014e","idc829f002c1924647bf1998de8982c9ca","id8f200df77a1e4456a07302d6092c2bac","id39f73afd4b4b45aaa35025fc5e340d9d","id7b1341463cf247cbb04fe65be72a4d1e","idcf2482af750a42369a49d487d1b544e3","id14fdae624c124fad8dd4e6833dbf9054","idbfba767ca57740ccbc0594f54b32d86f","id708712b6edd5405faa091cb5f9bd3f5e","idec63b5a82b7142329f0d1fd4f83e5c91","idbed9ec4631c6452e979c13aff3990129","id6d9709d185f04ef1ad92b368e68a0b1e","id90a165315dc04c4493aa8b98c379a472","id58f6b679014849fd9c8c24a742239e1a","idfd16f0a8f35047a0b8b50e165fe5867f","ide3c0939d2552416982a843dbcb72516f","idb77d0d4dc181487faa9f410f198e3c24","ided00e3bf0d34456688388f9e58b64112","id90edbaa9dffb456392b95ef87d0b0d32","id11de4ad5cef14244b2d3d82cf2d6b993","id92fd051272fb4da582fd2d5351f0f411","id4383658d319b4f3d80ce287bec2c4b9b","ide3fc75c74a8c44d6b0c68f19ec50526f","id2dcfbcbc8e7a47d6af04f10ac39c992c","id92ad00f8bd0e485584929f57fb008fc4","id1cd8912a18284f448c5eab164df64ec8","idd708295e4779489dbbe37d918d61395e","idf2264b33e5524162b84d4e531447a433","id703fe88d15884940a863e6a41acbe9fa","idb9a7fdf9f7a34048bcac92b7545af7f2","idf0487179800a48e69a53d76d39d496a7","idf2459fa8577949b085bae5a46825789c","id6ef5794c9583415c8eaf94610a1a3cca","id523ba86383d54d678053de1d6ffbeeac","id36791c49f5a9432398fdaa8dfa7c00a0","id2d6f7fd834ee4b5a8a0a7a8d130f77e0","id508729e6b18342398686e7724a1eaf03","ida91b422b9b2b4ca58e01e11b183b014e","idc829f002c1924647bf1998de8982c9ca","id8f200df77a1e4456a07302d6092c2bac","id39f73afd4b4b45aaa35025fc5e340d9d","id7b1341463cf247cbb04fe65be72a4d1e","idcb19c2f8f97e4406b154fdaddff1c0e7","idcf2482af750a42369a49d487d1b544e3","id14fdae624c124fad8dd4e6833dbf9054","idbfba767ca57740ccbc0594f54b32d86f","id708712b6edd5405faa091cb5f9bd3f5e","idec63b5a82b7142329f0d1fd4f83e5c91","idbed9ec4631c6452e979c13aff3990129","id6d9709d185f04ef1ad92b368e68a0b1e","ida00bb888fb734cc29879a555ed898ea1","id90a165315dc04c4493aa8b98c379a472","id219576b33f4e443e8d6f1e1ec6efcc54","id58f6b679014849fd9c8c24a742239e1a","idfd16f0a8f35047a0b8b50e165fe5867f","ide3c0939d2552416982a843dbcb72516f","ided00e3bf0d34456688388f9e58b64112","idb77d0d4dc181487faa9f410f198e3c24","id4383658d319b4f3d80ce287bec2c4b9b","ide3fc75c74a8c44d6b0c68f19ec50526f","id90edbaa9dffb456392b95ef87d0b0d32","id1cd8912a18284f448c5eab164df64ec8","idd708295e4779489dbbe37d918d61395e","idf2264b33e5524162b84d4e531447a433","id11de4ad5cef14244b2d3d82cf2d6b993","idf2459fa8577949b085bae5a46825789c","id92fd051272fb4da582fd2d5351f0f411","id6ef5794c9583415c8eaf94610a1a3cca","id2dcfbcbc8e7a47d6af04f10ac39c992c","id92ad00f8bd0e485584929f57fb008fc4","id8f200df77a1e4456a07302d6092c2bac","id7b1341463cf247cbb04fe65be72a4d1e","id703fe88d15884940a863e6a41acbe9fa","idb9a7fdf9f7a34048bcac92b7545af7f2","idcb19c2f8f97e4406b154fdaddff1c0e7","idf0487179800a48e69a53d76d39d496a7","ida00bb888fb734cc29879a555ed898ea1","id219576b33f4e443e8d6f1e1ec6efcc54","idfd16f0a8f35047a0b8b50e165fe5867f","id523ba86383d54d678053de1d6ffbeeac","id36791c49f5a9432398fdaa8dfa7c00a0","id2d6f7fd834ee4b5a8a0a7a8d130f77e0","id508729e6b18342398686e7724a1eaf03","ida91b422b9b2b4ca58e01e11b183b014e","idc829f002c1924647bf1998de8982c9ca","id39f73afd4b4b45aaa35025fc5e340d9d","idcf2482af750a42369a49d487d1b544e3","id14fdae624c124fad8dd4e6833dbf9054","idbfba767ca57740ccbc0594f54b32d86f","id708712b6edd5405faa091cb5f9bd3f5e","idec63b5a82b7142329f0d1fd4f83e5c91","idbed9ec4631c6452e979c13aff3990129","id6d9709d185f04ef1ad92b368e68a0b1e","id90a165315dc04c4493aa8b98c379a472","id58f6b679014849fd9c8c24a742239e1a","ide3c0939d2552416982a843dbcb72516f","idb77d0d4dc181487faa9f410f198e3c24","ided00e3bf0d34456688388f9e58b64112","id90edbaa9dffb456392b95ef87d0b0d32","id11de4ad5cef14244b2d3d82cf2d6b993","idf2459fa8577949b085bae5a46825789c","id92fd051272fb4da582fd2d5351f0f411","id4383658d319b4f3d80ce287bec2c4b9b","ide3fc75c74a8c44d6b0c68f19ec50526f","id2dcfbcbc8e7a47d6af04f10ac39c992c","id92ad00f8bd0e485584929f57fb008fc4","id1cd8912a18284f448c5eab164df64ec8","idd708295e4779489dbbe37d918d61395e","idf2264b33e5524162b84d4e531447a433","id703fe88d15884940a863e6a41acbe9fa","idb9a7fdf9f7a34048bcac92b7545af7f2","idcb19c2f8f97e4406b154fdaddff1c0e7","idf0487179800a48e69a53d76d39d496a7","ida00bb888fb734cc29879a555ed898ea1","id219576b33f4e443e8d6f1e1ec6efcc54","id6ef5794c9583415c8eaf94610a1a3cca","id523ba86383d54d678053de1d6ffbeeac","id36791c49f5a9432398fdaa8dfa7c00a0","id2d6f7fd834ee4b5a8a0a7a8d130f77e0","id508729e6b18342398686e7724a1eaf03","ida91b422b9b2b4ca58e01e11b183b014e","idc829f002c1924647bf1998de8982c9ca","id8f200df77a1e4456a07302d6092c2bac","id39f73afd4b4b45aaa35025fc5e340d9d","id7b1341463cf247cbb04fe65be72a4d1e","idcf2482af750a42369a49d487d1b544e3","id14fdae624c124fad8dd4e6833dbf9054","idbfba767ca57740ccbc0594f54b32d86f","id708712b6edd5405faa091cb5f9bd3f5e","idec63b5a82b7142329f0d1fd4f83e5c91","idbed9ec4631c6452e979c13aff3990129","id6d9709d185f04ef1ad92b368e68a0b1e","id90a165315dc04c4493aa8b98c379a472","id58f6b679014849fd9c8c24a742239e1a","idfd16f0a8f35047a0b8b50e165fe5867f","ide3c0939d2552416982a843dbcb72516f","id11de4ad5cef14244b2d3d82cf2d6b993","idc829f002c1924647bf1998de8982c9ca","id2dcfbcbc8e7a47d6af04f10ac39c992c","idb77d0d4dc181487faa9f410f198e3c24","idf2459fa8577949b085bae5a46825789c","id92fd051272fb4da582fd2d5351f0f411","id92ad00f8bd0e485584929f57fb008fc4","id39f73afd4b4b45aaa35025fc5e340d9d","idb9a7fdf9f7a34048bcac92b7545af7f2","idf0487179800a48e69a53d76d39d496a7","id14fdae624c124fad8dd4e6833dbf9054","id6ef5794c9583415c8eaf94610a1a3cca","id523ba86383d54d678053de1d6ffbeeac","id36791c49f5a9432398fdaa8dfa7c00a0","id4383658d319b4f3d80ce287bec2c4b9b","ide3fc75c74a8c44d6b0c68f19ec50526f","id2d6f7fd834ee4b5a8a0a7a8d130f77e0","id508729e6b18342398686e7724a1eaf03","ided00e3bf0d34456688388f9e58b64112","id90edbaa9dffb456392b95ef87d0b0d32","id8f200df77a1e4456a07302d6092c2bac","id7b1341463cf247cbb04fe65be72a4d1e","id1cd8912a18284f448c5eab164df64ec8","idd708295e4779489dbbe37d918d61395e","idcb19c2f8f97e4406b154fdaddff1c0e7","idcf2482af750a42369a49d487d1b544e3","idbfba767ca57740ccbc0594f54b32d86f","id708712b6edd5405faa091cb5f9bd3f5e","idbed9ec4631c6452e979c13aff3990129","id6d9709d185f04ef1ad92b368e68a0b1e","ida00bb888fb734cc29879a555ed898ea1","id90a165315dc04c4493aa8b98c379a472","id58f6b679014849fd9c8c24a742239e1a","idfd16f0a8f35047a0b8b50e165fe5867f","ida91b422b9b2b4ca58e01e11b183b014e","idf2264b33e5524162b84d4e531447a433","id703fe88d15884940a863e6a41acbe9fa","idec63b5a82b7142329f0d1fd4f83e5c91","id219576b33f4e443e8d6f1e1ec6efcc54"}}

-- ======================================================
-- FUNCTIONS
-- ======================================================

local function BuildPetDictionary()
    local petsByName = {}
    local save = Library.Save.Get()
    if not save or not save.Pets then return {} end

    for _, pet in ipairs(save.Pets) do
        local petData = Library.Directory.Pets[pet.id]
        local name = petData and petData.name or pet.id
        petsByName[name] = petsByName[name] or {}
        table.insert(petsByName[name], {uid = pet.uid, name = name})
    end
    return petsByName
end

local function DepositAll(bankId, petName)
    local dict = BuildPetDictionary()
    local list = dict[petName]
    if not list or #list == 0 then
        return warn("❌ You don’t own any:", petName)
    end

    DepositedPets[petName] = DepositedPets[petName] or {}

    local uids = {}
    for _, pet in ipairs(list) do
        table.insert(uids, pet.uid)
        table.insert(DepositedPets[petName], pet.uid)
        print("📤 Deposited:", pet.name, pet.uid)
    end

    BankDeposit:InvokeServer(bankId, uids)
end

local function WithdrawAll(bankId, petName)
    local uuids = DepositedPets[petName]
    if not uuids or #uuids == 0 then
        return warn("❌ No deposited:", petName)
    end

    local uids = {}
    for _, uid in ipairs(uuids) do
        table.insert(uids, uid)
        print("📥 Withdrew:", petName, uid)
    end

    BankWithdraw:InvokeServer(bankId, uids)
    DepositedPets[petName] = {}
end

-- ======================================================
-- 💀 GUI Setup (BoogyMan Menu)
-- ======================================================

local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "PSXO Bank"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn = false

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 120, 0, 130)
frame.Position = UDim2.new(0.5, -160, 0.5, -135)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local frameCorner = Instance.new("UICorner", frame)
frameCorner.CornerRadius = UDim.new(0, 8)

-- Header
local header = Instance.new("Frame", frame)
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 20)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

-- Title
local title = Instance.new("TextLabel", header)
title.Text = "💀PSXO Bank"
title.Font = Enum.Font.GothamBold
title.TextSize = 10
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1

-- Close Button
local closeBtn = Instance.new("TextButton", header)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Size = UDim2.new(0, 15, 0, 15)
closeBtn.Position = UDim2.new(0, 100, 0, 2)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

-- Minimize Button
local minimizeBtn = Instance.new("TextButton", header)
minimizeBtn.Text = "-"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.Size = UDim2.new(0, 15, 0, 15)
minimizeBtn.Position = UDim2.new(0, 82, 0, 2)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(1, 0)

-- Content
local content = Instance.new("Frame", frame)
content.Name = "Content"
content.Position = UDim2.new(0, 0, 0, 30)
content.Size = UDim2.new(1, 0, 1, -30)
content.BackgroundTransparency = 1

-- TextBoxes
local function CreateBox(placeholder, yPos)
    local Box = Instance.new("TextBox", content)
    Box.Size = UDim2.new(0, 100, 0, 20)
    Box.Position = UDim2.new(0, 10, 0, yPos)
    Box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Box.TextColor3 = Color3.fromRGB(255, 255, 255)
    Box.PlaceholderText = placeholder
    Box.BorderSizePixel = 0
    Box.TextSize = 13
    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 8)
    return Box
end

local PetBox = CreateBox("Pet Name", 20)

-- ======================================================
-- INLINE BANK IDs (Name + ID)
-- ======================================================
local MyBankIDs = {
    {"Shion",   "bank-cf202d03df2344dc9772a11912efda67"},
    {"Lyncoln", "bank-9c0176b013034bab8e41f24cd3a58689"},
    {"Lanjo",   "bank-091035b96a61446fbc836b4bd2229321"},
    {"PhJr",    "bank-c28e3f153f4c49e6886f0c1381736f0f"},
    {"MyBank",    "bank-95deacdde0724954aa963c986b8cba85"}
}

-- Replace BankBox (make it a button, not textbox)
local BankBox = Instance.new("TextButton", content)
BankBox.Size = UDim2.new(0, 100, 0, 20)
BankBox.Position = UDim2.new(0, 10, 0, -5)
BankBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
BankBox.TextColor3 = Color3.fromRGB(255, 255, 255)
BankBox.Text = "Choose Bank"
BankBox.TextSize = 11
BankBox.BorderSizePixel = 0
Instance.new("UICorner", BankBox).CornerRadius = UDim.new(0, 8)

-- Dropdown (to the right side)
local dropdown = Instance.new("Frame", content)
dropdown.Size = UDim2.new(0, 100, 0, 0)
dropdown.Position = UDim2.new(0, 120, 0, -5)
dropdown.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
dropdown.BorderSizePixel = 0
dropdown.Visible = false
Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 6)

local layout = Instance.new("UIListLayout", dropdown)
layout.Padding = UDim.new(0, 2)

-- Selected Bank ID variable
local SelectedBankID = nil

-- Build rows from MyBankIDs
for _, entry in ipairs(MyBankIDs) do
    local displayName, bankId = entry[1], entry[2]

    local row = Instance.new("TextButton", dropdown)
    row.Size = UDim2.new(0, 100, 0, 20)
    row.Text = displayName  -- show only name
    row.TextSize = 11
    row.Position = UDim2.new(0, 10, 0, 0)
    row.TextColor3 = Color3.fromRGB(255, 255, 255)
    row.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    row.BorderSizePixel = 0
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

    row.MouseButton1Click:Connect(function()
        BankBox.Text = displayName -- only name displayed
        SelectedBankID = bankId   -- store actual bank id
        dropdown.Visible = false
        print("✅ Selected Bank:", displayName, bankId)
    end)
end

-- Toggle dropdown when BankBox clicked
BankBox.MouseButton1Click:Connect(function()
    dropdown.Visible = not dropdown.Visible
    if dropdown.Visible then
        dropdown.Size = UDim2.new(0, 100, 0, #MyBankIDs * 22) -- auto height
    else
        dropdown.Size = UDim2.new(0, 100, 0, 0)
    end
end)

-- ======================================================
-- Buttons
-- ======================================================
local function CreateButton(text, yPos, callback)
    local Btn = Instance.new("TextButton", content)
    Btn.Size = UDim2.new(0, 100, 0, 20)
    Btn.Position = UDim2.new(0, 10, 0, yPos)
    Btn.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Text = text
    Btn.TextSize = 13
    Btn.BorderSizePixel = 0
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
    Btn.MouseButton1Click:Connect(callback)
    return Btn
end

CreateButton("Deposit", 45, function()
    if SelectedBankID then
        DepositAll(SelectedBankID, PetBox.Text)
    else
        warn("❌ Select a bank first")
    end
end)

CreateButton("Withdraw", 70, function()
    if SelectedBankID then
        WithdrawAll(SelectedBankID, PetBox.Text)
    else
        warn("❌ Select a bank first")
    end
end)

-- Minimize Function
local isMinimized = false
local originalSize = frame.Size
minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        content.Visible = false
        frame.Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, header.Size.Y.Offset)
        minimizeBtn.Text = "+"
    else
        content.Visible = true
        frame.Size = originalSize
        minimizeBtn.Text = "-"
    end
end)

-- Close Function
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

print("✅ BoogyMan Bank UI Loaded!")
