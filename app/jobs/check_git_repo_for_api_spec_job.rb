## 
# This job gets called to extract the open api spec from a git repo
# This is the case, if 
# 
#       a) a new repo is submitted to gitlab
#       b) a new spec version was commited and pushed to gitlab
# 
# It pulls the repo, extracts and validates the spec, checks for changes and saves if these apply
# The job deletes the repo afterwards, as there is no need to keep a local copy

class CheckGitRepoForApiSpecJob < ApplicationJob
    queue_as :default
    require 'git'



    ##
    # performs the job via `ActiveJob`, can hence be queued for later execution or be run in a parallelized way
    # @param [TransparencyHub::Service] A service to whom the Api Spec belongs
    # 
    def perform(service, commit, branch)
        logger.debug ("CheckGitRepoForApiSpecJob::perform ==> Trying to extract open api spec for #{service.name}")
        if service.gitlab_repo_url
            logger.debug ("CheckGitRepoForApiSpecJob::perform ==> Git Uri present")

            git_path = service.repo_directory
            if File.directory?(git_path)
                # if the git repo is already present, just pull it
                logger.debug ("CheckGitRepoForApiSpecJob::perform ==> Repo already present")
                begin
                    git = Git.open(git_path)
                    logger.debug ("CheckGitRepoForApiSpecJob::perform ==> Trying to open local repo")
                rescue ArgumentError
                    logger.error ("CheckGitRepoForApiSpecJob::perform ==> PULLing failed")
                    # wrong path
                    # in this case try to just pull repo again, hence no need to do a thing
                end
                if git 
                    logger.debug ("CheckGitRepoForApiSpecJob::perform ==> Trying to PULL now")
                    git.pull
                end
            end
            if not git 
                # if it does not yet exist instead clone it
                logger.debug ("CheckGitRepoForApiSpecJob::perform ==> No repo found. Trying to CLONE")
                begin 
                    git = Git.clone(service.gitlab_repo_url, service.name, :path => Rails.root + 'data/git_repos/')
                # ######################
                # TODO
                # Implement proper way to handle these errors
                # Somehow the developer should see within Transparency Hub, if a webhook failed
                # ######################
                rescue Git::GitExecuteError
                    logger.error ("CheckGitRepoForApiSpecJob::perform ==> CLONing failed")
                    return false
                rescue
                    logger.error ("CheckGitRepoForApiSpecJob::perform ==> CLONing failed")
                    return false
                end
            end


            if git 
                # Job should never be called, if this ignore file is present, but still check it
                unless File.exists?('.transparencyhub-ignore')
                    logger.debug ("CheckGitRepoForApiSpecJob::perform ==> Git repo present. Trying to find and extract Spec now")
                    file_path = git.dir.path + '/api_spec/open_api_spec.yml'
                    if File.exists?(file_path)
                        logger.debug ("CheckGitRepoForApiSpecJob::perform ==> Spec found. Will create new TransparencyHub::ApiSpec now")
                        # following the transparency hub convention these files should exist, but stil check it
                        
                        # ######################
                        # TODO
                        # Validate JSON
                        # ######################


                        spec = ApiSpec.new()
                        spec.open_api_specification.attach(io: File.open(file_path), filename: 'spec.yml')
                        spec.service = service
                        spec.description = "Added by Git Webhook CI"
                        spec.commit_message = commit[:message]
                        spec.commit_url = commit[:url]
                        spec.author = commit[:author][:name]
                        spec.branch = branch

                        # ######################
                        # TODO
                        # add commit message to ApiSpec
                        # ######################
                        
                        spec.save
                    else
                        logger.error ("CheckGitRepoForApiSpecJob::perform ==> No Api Spec present")
                        # ######################
                        # TODO
                        # Add note or similar to Service, warning, that no spec is present
                        # ######################
                        return false
                    end
                else
                    logger.debug ("CheckGitRepoForApiSpecJob::perform ==> Found IGNORE file, skipping further action")
                end
            else
                # Git pulling/cloning did not work out
                logger.error ("CheckGitRepoForApiSpecJob::perform ==> No git Repo present. Neither pulling nor cloning worked out")
                return false
            end
        end
    end

end
