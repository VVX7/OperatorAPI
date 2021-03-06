#[
    Author: Roger Johnston, Twitter: @VV_X_7
    License: Apache License 2.0
]#

import tables
import jsony
import typetraits

type
    Account* = ref object
        email*: string
        tag*: string
        license*: string
        badges*: seq[string]
        token*: string
    Adversary* = ref object
        id*: string
        name*: string
        goals*: seq[Goal]
        ttps*: seq[string]
    AdversaryUpdate* = ref object
        add*: seq[string]
        remove*: seq[string]
    Agent* = ref object
        name*: string
        label*: string
        history*: seq[string]
        queue*: seq[string]
        links*: seq[Link]
        facts*: Table[string, seq[Fact]]
        locked*: bool
        location*: string
        target*: string
        hostname*: string
        state*: int
        key*: string
        busy*: bool
        handler*: AgentHandler
        interval*: int
        platform*: string
        executors*: seq[string]
        agentRange*: string
        sleep*: int
        automaticFacts*: seq[Fact]
    AgentHandler* = ref object
        name*: string
        active*: bool
    Attack* = ref object
        id*: string
        name*: string
        description*: string
        tactic*: string
        technique*: Technique
        platforms*: Platform
        metadata*: AttackMetadata
        modified*: bool
    AttackVersion* = ref object
        version*: int
        checksum*: string
        license*: string
        releaseDate*: string
    AttackMetadata* = ref object
        version*: int
        license*: string
        tags*: seq[string]
        authors*: seq[string]
        enabled*: bool
        checksum*: string
        releaseDate*: string
        latest*: AttackVersion
    Challenge* = ref object
        id*: string
        key*: string
        attempts*: int
        completed*: int
        difficulty*: int
        flag*: Flag
    CommandVariant* = ref object
        command*: string
        payload*: string
    Command* = ref object
        command*: string
        payload*: string
        variants*: seq[CommandVariant]
    Course* = ref object
        id*: string
        name*: string
        description*: string
        challenges*: seq[Challenge]
    Executor* = ref object
        psh*: Command
        exec*: Command
        cmd*: Command
        sh*: Command
        keyword*: Command
    Fact* = ref object
        host*: string
        key*: string
        value*: string
        linkID*: string
        ttp*: string
    Flag* = ref object
        id*: string
        flagTemplate*: FlagTemplate
        name*: string
        challenge*: string
        context*: string
        resources*: FlagResources
        answer*: string
        hints*: seq[string]
        blocks*: Table[string, string]
    FlagTemplate* = ref object
        name*: string
        data*: seq[string]
    FlagResources* = ref object
        links*: seq[string]
    Goal* = ref object
        key*: string
        val*: string
        criteria*: string
    InternalSettings* = ref object
        local*: Workspace
        identity*: string
        account*: Account
        version*: string
    Instruction* = ref object
        id*: string
        operation*: string
        ttp*: string
        facts*: Table[string, string]
        executor*: string
    Link* = ref object
        unique*: string
        tag*: string
        host*: string
        platform*: string
        timestamp*: int
        ttp*: string
        executor*: string
        request*: string
        response*: string
        status*: int
        pid*: int
        tactic*: string
        technique*: string
        operation*: string
    OperatorClient* = ref object
        api*: RestApi
    OperationAudit* = ref object
        status*: int
        links*: seq[string]
    Operation* = ref object
        id*: string
        adversary*: Adversary
        agentRange*: string
        audit*: Table[string, OperationAudit]
        opStart*: string
        opEnd*: string
    Preferences* = ref object
        notices*: seq[string]
    Program* = ref object
        id*: string
        name*: string
        description*: string
        license*: string
        courses*: seq[Course]
    Plugin* = ref object
        name*: string
        description*: string
        custom*: Table[string, string]
    Platform* = ref object
        windows*: Executor
        linux*: Executor
        darwin*: Executor
        global*: Executor
    Redirector* = ref object
        name*: string
    RestError* = object of CatchableError
    RestApi* = ref object
        token*: string
        port*: string
        url*: string
        endpoints*: Table[string, RequestStatus]
    RequestStatus* = ref object
        processing*: bool
    Schedule* = ref object
        agentRange*: string
        adversary*: string
        dayOfWeek*: string
        hour*: string
        minute*: string
        timeout*: int
    Technique* = ref object
        id*: string
        name*: string
    Tactic* = ref object
        tactic*: string
        techniques*: Table[string, Technique]
    WorkspaceKeys* = ref object
        agent*: seq[string]
        data*: seq[string]
    WorkspacePublisher* = ref object
        local*: bool
        prelude*: bool
    Workspace* = ref object
        workspace*: string
        keys*: WorkspaceKeys
        server*: string
        tcpPort*: int
        udpPort*: int
        httpPort*: int
        grpcPort*: int
        shellPort*: int
        publishers*: WorkspacePublisher
        redirectors: Redirector
        sources*: seq[string]
        protect*: int
        preferences*: Preferences
        gatekeepers*: seq[string]

# jsony dumpHooks
# https://github.com/treeform/jsony#proc-dumphook-can-be-used-to-serializer-into-custom-representation
#
# But why?
#
# jsony serializes objects without assigned property values as `null`.
#
# The Operator API chokes on null values so we test if 
# the objects to be serialized contain data and omit them if not.
#
# If your JSON is haunted this is probably the reason.

proc dumpHook*(s: var string, v: Adversary) =
    s.add '{'
    s.add("\"id\":")
    s.dumpHook(v.id)
    s.add(", \"name\":")
    s.dumpHook(v.name)
    if len(v.goals) > 0:
        s.add(", \"goals\":")
        s.dumpHook(v.goals)
    s.add(", \"ttps\":")
    s.dumpHook(v.ttps)
    s.add '}'

proc renameHook*(v: var Agent|Schedule, fieldName: var string) =
  if fieldName == "range":
    fieldName = "agentRange"

proc dumpHook*(s: var string, v: Agent) =
    s.add '{'
    s.add("\"label\":")
    s.dumpHook(v.label)
    s.add(", \"name\":")
    s.dumpHook(v.name)
    if len(v.history) > 0:
        s.add(", \"history\":")
        s.dumpHook(v.history)
    if len(v.queue) > 0:
        s.add(", \"queue\":")
        s.dumpHook(v.queue)
    if len(v.links) > 0:
        s.add(", \"links\":")
        s.dumpHook(v.links)
    if len(v.queue) > 0:
        s.add(", \"queue\":")
        s.dumpHook(v.queue)
    
    var first: bool = true
    for name, value in v.facts.pairs:
        if len(value) > 0:
            if first:
                s.add("\"" & name & "\":")
                s.dumpHook(value)
                first = false
            else:
                s.add(", \"" & name & "\":")
                s.dumpHook(value)

    s.add(", \"locked\":")
    s.dumpHook(v.locked)
    s.add(", \"location\":")
    s.dumpHook(v.location)
    s.add(", \"target\":")
    s.dumpHook(v.target)
    s.add(", \"hostname\":")
    s.dumpHook(v.hostname)
    s.add(", \"state\":")
    s.dumpHook(v.state)
    s.add(", \"key\":")
    s.add(", \"key\":")
    s.dumpHook(v.key)
    s.add(", \"busy\":")
    s.dumpHook(v.busy)
    if not v.handler.isNil():
        s.add(", \"handler\":")
        s.dumpHook(v.handler)
    s.add(", \"interval\":")
    s.dumpHook(v.interval)
    s.add(", \"platform\":")
    s.dumpHook(v.platform)
    s.add(", \"executors\":")
    s.dumpHook(v.executors)   
    s.add(", \"range\":")
    s.dumpHook(v.agentRange)
    if len(v.automaticFacts) > 0:
        s.add(", \"automaticFacts\":")
        s.dumpHook(v.automaticFacts)
    s.add '}'

proc dumpHook*(s: var string, v: AgentHandler) =
    s.add '{'
    s.add("\"name\":")
    s.dumpHook(v.name)
    s.add '}'

proc dumpHook*(s: var string, v: Attack) =
    s.add '{'
    s.add("\"id\":")
    s.dumpHook(v.id)
    s.add(", \"name\":")
    s.dumpHook(v.description)
    s.add(", \"description\":")
    s.dumpHook(v.description)
    s.add(", \"tactic\":")
    s.dumpHook(v.tactic)
    s.add(", \"technique\":")
    s.dumpHook(v.technique)
    s.add(", \"platforms\":")
    s.dumpHook(v.platforms)
    s.add(", \"metadata\":")
    s.dumpHook(v.metadata)
    s.add(", \"modified\":")
    s.dumpHook(v.modified)
    s.add '}'

proc dumpHook*(s: var string, v: AttackMetadata) =
    s.add '{'
    s.add("\"version\":")
    s.dumpHook(v.version)
    s.add(", \"license\":")
    s.dumpHook(v.license)
    s.add(", \"tags\":")
    s.dumpHook(v.tags)
    s.add(", \"authors\":")
    s.dumpHook(v.authors)
    s.add(", \"enabled\":")
    s.dumpHook(v.enabled)
    if v.checksum != "":
        s.add(", \"checksum\":")
        s.dumpHook(v.checksum)
    s.add(", \"releaseDate\":")
    s.dumpHook(v.releaseDate)
    if not v.latest.isNil():
        s.add(", \"latest\":")
        s.dumpHook(v.latest)
    s.add '}'

proc dumpHook*(s: var string, v: Challenge) =
    s.add '{'
    s.add("\"id\":")
    s.dumpHook(v.id)
    s.add(", \"key\":")
    s.dumpHook(v.key)
    s.add(", \"attempts\":")
    s.dumpHook(v.attempts)
    s.add(", \"completed\":")
    s.dumpHook(v.completed)
    s.add(", \"difficulty\":")
    s.dumpHook(v.difficulty)
    if not v.flag.isNil():
        s.add(", \"flag\":")
        s.dumpHook(v.flag)
    s.add '}'

proc dumpHook*(s: var string, v: Course) =
    s.add '{'
    s.add("\"id\":")
    s.dumpHook(v.id)
    s.add(", \"name\":")
    s.dumpHook(v.name)
    s.add(", \"description\":")
    s.dumpHook(v.description)
    if len(v.challenges) > 0:
        s.add(", \"challenges\":")
        s.dumpHook(v.challenges)
    s.add '}'

proc dumpHook*(s: var string, v: Command) =
    s.add '{'
    s.add("\"command\":")
    s.dumpHook(v.command)
    s.add(", \"payload\":")
    s.dumpHook(v.payload)
    if len(v.variants) > 0:
        s.add(", \"variants\":")
        s.dumpHook(v.variants)
    s.add '}'

proc dumpHook*(s: var string, v: Executor|Platform) =
    var first: bool = true
    s.add '{'
    for name, value in v[].fieldPairs:
        if not value.isNil():
            if first:
                s.add("\"" & name & "\":")
                s.dumpHook(value)
                first = false
            else:
                s.add(", \"" & name & "\":")
                s.dumpHook(value)
    s.add '}'

proc dumpHook*(s: var string, v: Fact) =
    s.add '{'
    s.add("\"host\":")
    s.dumpHook(v.host)
    s.add(", \"key\":")
    s.dumpHook(v.key)
    s.add(", \"value\":")
    s.dumpHook(v.value)
    s.add(", \"linkID\":")
    s.dumpHook(v.linkID)
    s.add(", \"ttp\":")
    s.dumpHook(v.ttp)
    s.add '}'

proc renameHook*(v: var Flag, fieldName: var string) =
  if fieldName == "template":
    fieldName = "flagTemplate"

proc dumpHook*(s: var string, v: Flag) =
    s.add '{'
    s.add("\"id\":")
    s.dumpHook(v.id)
    s.add(", \"template\":")
    s.dumpHook(v.flagTemplate)
    s.add(", \"name\":")
    s.dumpHook(v.name)
    s.add(", \"challenge\":")
    s.dumpHook(v.challenge)
    s.add(", \"context\":")
    s.dumpHook(v.context)
    s.add(", \"resources\":")
    s.dumpHook(v.resources)
    s.add(", \"answer\":")
    s.dumpHook(v.answer)
    if len(v.hints) > 0:
        s.add(", \"hints\":")
        s.dumpHook(v.hints)
    s.add(", \"blocks\":")
    s.dumpHook(v.blocks)
    s.add '}' 

proc dumpHook*(s: var string, v: FlagTemplate) =
    s.add '{'
    s.add("\"name\":")
    s.dumpHook(v.name)
    s.add(", \"data\":")
    s.dumpHook(v.data)
    s.add '}' 

proc dumpHook*(s: var string, v: FlagResources) =
    s.add '{'
    s.add("\"links\":")
    s.dumpHook(v.links)
    s.add '}' 

proc dumpHook*(s: var string, v: Instruction) =
    s.add '{'
    s.add("\"id\":")
    s.dumpHook(v.id)
    s.add(", \"operation\":")
    s.dumpHook(v.operation)
    s.add(", \"ttp\":")
    s.dumpHook(v.ttp)
    s.add(", \"facts\":")
    s.dumpHook(v.facts)
    s.add(", \"executor\":")
    s.dumpHook(v.executor)
    s.add '}'

proc dumpHook*(s: var string, v: Program) =
    s.add '{'
    s.add("\"id\":")
    s.dumpHook(v.id)
    s.add(", \"name\":")
    s.dumpHook(v.name)
    s.add(", \"description\":")
    s.dumpHook(v.description)
    s.add(", \"license\":")
    s.dumpHook(v.license)
    if len(v.courses) > 0:
        s.add(", \"courses\":")
        s.dumpHook(v.courses)
    s.add '}'

proc dumpHook*(s: var string, v: Schedule) =
    s.add '{'
    s.add("\"range\":")
    s.dumpHook(v.agentRange)
    s.add(", \"adversary\":")
    s.dumpHook(v.adversary)
    s.add(", \"dayOfWeek\":")
    s.dumpHook(v.dayOfWeek)
    s.add(", \"hour\":")
    s.dumpHook(v.hour)
    s.add(", \"minute\":")
    s.dumpHook(v.minute)
    if name(v.timeout.type) == "int":
        s.add(", \"timeout\":")
        s.dumpHook(v.timeout)
    s.add '}'

proc dumpHook*(s: var string, v: Technique) =
    s.add '{'
    s.add("\"id\":")
    s.dumpHook(v.id)
    s.add(", \"name\":")
    s.dumpHook(v.name)
    s.add '}'
