---comment
JOB.RefreshData = function ()
    local JobsData = GlobalState.JobsData
    local count = 0
    W.TriggerCallback("jobcreatorv2:server:edit", function(jobs)
        for k,v in pairs(jobs) do
            count = count + 1
        end
        print(count)
        SendNUIMessage({ type = "loadData", JobsData = jobs })
    end)
end