#[
    Author: Roger Johnston, Twitter: @VV_X_7
    License: Apache License 2.0
]#

import options, jsony, tables, strutils
include objects/typedefs

proc newAccount*(data: string): Account = 
    result = data.fromJson(Account)
    
proc newAdversary*(data: string): Adversary =
    result = data.fromJson(Adversary)

proc newAgent*(data: string): Agent =
    result = data.fromJson(Agent)

proc newAgentHandler*(data: string): AgentHandler =
    result = data.fromJson(AgentHandler)

proc newAttack*(data: string): Attack =
    result = data.fromJson(Attack)

proc newAttackMetadata*(data: string): AttackMetadata = 
    result = data.fromJson(AttackMetadata)

proc newAttackVersion*(data: string): AttackVersion = 
    result = data.fromJson(AttackVersion)

proc newChallenge*(data: string): Challenge = 
    result = data.fromJson(Challenge)

proc newCommand*(data: string): Command = 
    result = data.fromJson(Command)

proc newCommandVariant*(data: string): CommandVariant = 
    result = data.fromJson(CommandVariant)

proc newCourse*(data: string): Course = 
    result = data.fromJson(Course)

proc newExecutor*(data: string): Executor = 
    result = data.fromJson(Executor)

proc newFact*(data: string): Fact = 
    result = data.fromJson(Fact)

proc newFlag*(data: string): Flag = 
    result = data.fromJson(Flag)

proc newFlagResources*(data: string): FlagResources = 
    result = data.fromJson(FlagResources)

proc newFlagTemplate*(data: string): FlagTemplate = 
    result = data.fromJson(FlagTemplate)

proc newGoal*(data: string): Goal =
    result = data.fromJson(Goal)

proc newInstruction*(data: string): Instruction = 
    result = data.fromJson(Instruction)

proc newInternalSettings*(data: string): InternalSettings = 
    result = data.fromJson(InternalSettings)

proc newLink*(data: string): Link = 
    result = data.fromJson(Link)

proc newPlatform*(data: string): Platform = 
    result = data.fromJson(Platform)

proc newOperation*(data: string): Operation = 
    result = data.fromJson(Operation)

proc newOperationAudit*(data: string): OperationAudit = 
    result = data.fromJson(OperationAudit)

proc newOperatorClient*(token: string, port: string = "8888",
 url: string = "http://localhost"): OperatorClient =
    result = OperatorClient(
        api: RestApi(
            token: token,
            port: port,
            url: url
        )
    )

proc newProgram*(data: string): Program =
    result = data.fromJson(Program)

proc newPlugin*(data: string): Plugin = 
    result = data.fromJson(Plugin)

proc newPreferences*(data: string): Preferences = 
    result = data.fromJson(Preferences)

proc newRedirector*(data: string): Redirector = 
    result = data.fromJson(Redirector)

proc newSchedule*(data: string): Schedule = 
    result = data.fromJson(Schedule)

proc newWorkspace*(data: string): Workspace = 
    result = data.fromJson(Workspace)

proc newWorkspaceKeys*(data: string): WorkspaceKeys = 
    result = data.fromJson(WorkspaceKeys)

proc newWorkspacePublisher*(data: string): WorkspacePublisher = 
    result = data.fromJson(WorkspacePublisher)
