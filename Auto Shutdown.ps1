# Tagen ifrån https://www.ctrl.blog/entry/idle-task-scheduler-powershell.html

New-Item -Path 'C:\Program Files\auto' -ItemType Directory


New-Item -Path 'C:\Program Files\auto\ok.txt'


$TaskName = "Nordlo Auto Shutdown"

$service = New-Object -ComObject("Schedule.Service")
$service.Connect()
$rootFolder = $service.GetFolder("")

$taskdef = $service.NewTask(0)

# Creating task settings with some default properties plus
# the task’s idle settings; requiring 15 minutes idle time
$sets = $taskdef.Settings
$sets.AllowDemandStart = $true
$sets.Compatibility = 2
$sets.Enabled = $true
$sets.RunOnlyIfIdle = $true
$sets.IdleSettings.IdleDuration = "PT1M"
$sets.IdleSettings.WaitTimeout = "PT0M"
$sets.IdleSettings.StopOnIdleEnd = $true

# Creating an reoccurring daily trigger, limited to execute
# once per 40-minutes.
$trg = $taskdef.Triggers.Create(2)
$trg.StartBoundary = ([datetime]::Now).ToString("yyyy-MM-dd'T'HH:mm:ss")
$trg.Enabled = $true
$trg.DaysInterval = 1
$trg.Repetition.Duration = "P1D"
$trg.Repetition.Interval = "PT20M"
$trg.Repetition.StopAtDurationEnd = $true

# The command and command arguments to execute
$act = $taskdef.Actions.Create(0)
$act.Path = "C:\Windows\System32\shutdown.exe"
$act.Arguments = "-s"

# Register the task under the current Windows user
$user = [environment]::UserDomainName + "\" + [environment]::UserName
$rootFolder.RegisterTaskDefinition($TaskName, $taskdef, 6, $user, $null, 3)