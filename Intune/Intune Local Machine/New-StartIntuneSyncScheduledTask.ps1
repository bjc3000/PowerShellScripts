if (!(Get-ScheduledTask -TaskName 'Restart Intune service during setup' -ErrorAction SilentlyContinue)) {
    
    $newScheduledTaskSplat = @{
        Action      = New-ScheduledTaskAction -Execute 'intunemanagementextension://syncapp'
        Description = 'Start an intune sync action'
        Settings    = New-ScheduledTaskSettingsSet -Compatibility Vista -AllowStartIfOnBatteries -MultipleInstances IgnoreNew -ExecutionTimeLimit (New-TimeSpan -Hours 1)
        Trigger     = (New-ScheduledTaskTrigger -At ($Start = (Get-Date).AddMinutes(10)) -Once), (New-ScheduledTaskTrigger -At ($Start = (Get-Date).AddMinutes(20)) -Once), (New-ScheduledTaskTrigger -At ($Start = (Get-Date).AddMinutes(30)) -Once)
        Principal   = New-ScheduledTaskPrincipal -GroupId 'S-1-5-32-545' -RunLevel Limited
    }
    
    $ScheduledTask = New-ScheduledTask @newScheduledTaskSplat
    $ScheduledTask.Settings.DeleteExpiredTaskAfter = "PT0S"
    $ScheduledTask.Triggers[0].StartBoundary = $Start.ToString("yyyy-MM-dd'T'HH:mm:ss")
    $ScheduledTask.Triggers[0].EndBoundary = $Start.AddMinutes(60).ToString('s')
    
    Register-ScheduledTask -InputObject $ScheduledTask -TaskName 'Restart Intune service during setup'
}
