##
# This controller is an api-only controller that handels gitlab webhooks
# 
# 
class GitlabReposController < ApplicationController


    # ################
    # TODO
    # currently for local testing. Of course this shell work with actual tokens
    skip_before_action :verify_authenticity_token

    ##
    # This action handles all gitlab webhook requests
    # Gitlab does not differentiate between repo-creation and other pushes
    # Hence this action checks, if the service already exists and if it has a spec
    # 
    def update
        @status = {}
        @status[:status] = 'OK'
        @status[:message] = '-'

        # Git repos/groups should be configured in a way, that only push events trigger webhooks
        # Still check for it, so that only legit push events trigger this method
        if params&.has_key? 'object_kind' and params[:object_kind] == "push"
            if gitlab_url = params.dig(:project, :git_ssh_url)
                service = nil
                # check if service with this url exists
                if not service = check_service(gitlab_url)
                    # if no service exists from thios repo, create it
                    # If the service gets created this way, it will be an internal one
                    service = Service.create(gitlab_repo_url: gitlab_url, name: params.dig(:project, :name), internal: true, git_http_url: params.dig(:project, :git_http_url))
                    @status[:message] = "New Service created."
                end

                # ###################
                # TODO
                # Wenn der service frisch erstellt wurde, dann muss man schauen, ob überhaupt ne spec da ist. Kann ja sein, dass in dem push selbst da nichts geändert wurde 
                # aber die schon präsent ist
                # ###################

                # at this point service was either found or created
                if commits = params.dig(:commits)
                    # get all modified files from the commits that were done
                    # flatten array because each commit is an array itself but we just need the files
                    # uniq, because we are only interested IF a file has changed or was added. Several changes do not matter
                    
                    commits_with_spec_change =  commits.select {|c| 
                                                    (c[:added] + c[:modified]).flatten.uniq.include? "api_spec/open_api_spec.yml"  
                                                }

                    # check if a ignore file was added, if so mark service as ignored
                    if commits.select {|c| (c[:added]).flatten.uniq.include? ".transparencyhub-ignore"  }.size > 0
                        service.ignore = true
                        service.save
                    end

                    # modified_files = commits.map{|c| c[:modified]}.flatten.uniq
                    # added_files = commits.map{|c| c[:added]}.flatten.uniq
                    # all_changed_files = modified_files + added_files
                    

                    # ###################
                    # TODO
                    # also do sth if spec or ignorefile gets DELETED
                    # ###################

                    if commits_with_spec_change.size > 0 and not service.ignore
                        branchname = ""
                        if ref = params.dig(:ref) 
                            if ref[0..10] == "refs/heads/"
                                branchname = ref[11..-1]
                            end
                        end

                        # commits are in ascending order. Hence pass last commit to Job, as it contains the last change
                        if CheckGitRepoForApiSpecJob.perform_now(service, commits_with_spec_change.last, branchname)
                            # if so, trigger job, to extract newest version
                            @status[:message] += "Found changed/added ApiSpec. Calling Job to extract it"
                        else
                            @status[:status] = "Error"
                            @status[:message] = "Error Trying to extract ApiSpec"
                        end
                    end

                end
            end # gitlab uri
        end # params

    end

    def hello

    end


    private

    def check_service(gitlab_url)
        Service.find_by_gitlab_repo_url(gitlab_url)
    end

end
