require 'rubygems'
require 'mash'
require 'httparty'

module PBWiki
  class Client

    include HTTParty

    attr_accessor :name
    attr_accessor :read, :write, :admin

    def initialize(name, keys = {})
      @name = name
      @read, @write, @admin = keys.values_at(:read, :write, :admin)
    end

    # Gets the method corresponding to the PBWorks v2 API, with the requested parameters.
    def self.perform_api_request(verb, base_uri, format, secure, api_method, params = {})
      response = send(verb,
                        "/api_v2/",
                        :base_uri   => base_uri,
                        :query => {
                          :op       => api_method,
                          :_type    => 'jsontext'}.merge(params))
      response = response.gsub(/^\/\*-secure-/, '').gsub(/\*\/$/, '').strip if secure
      format == :json ? Mash.new(Crack::JSON.parse(response)) : response
    rescue Crack::ParseError
      raise "Malformed json response"
    end

    def request(verb, http_method, format, api_method, params, secure = true)
      uri_prefix  = http_method == :https ? 'https' : 'http'
      uri         = "#{uri_prefix}://#{@name}.pbworks.com/"

      self.class.perform_api_request(verb, uri, format, secure, api_method, params)
    end

    class << self
      alias old_method_missing method_missing
      def method_missing(name, *args, &blk)
        if name.to_s =~ /^pb_([a-z]+_)*(read|write|admin)$/

          raise "A method name must be defined" unless args.size >= 1
          raise "An API operation method name should be defined" unless args.size >= 2

          s_method_name   = name.to_s.split('_')
          def_parameters  = s_method_name[1...-1]    # Get the method words between
          action_key      = s_method_name.last
          method_name     = args.shift
          api_method_name = args.shift
          required_keys   = args

          define_method(method_name) do |*api_method_params_optional_args|
            api_method_params = api_method_params_optional_args[0] || {}
            unless required_keys.all?{|key| api_method_params.keys.include?(key)}
              raise "Error. Api method requires the following keys: #{args.inspect}"
            end
            verb        = def_parameters.include?('post')  ? :post  : :get
            http_method = def_parameters.include?('https') ? :https : :http
            format      = def_parameters.include?('plain') ? :plain : :json
            secure      = def_parameters.include?('basic') ? false  : true
            api_method_params.merge!("#{action_key}_key".to_sym => instance_variable_get("@#{action_key}"))
            request(verb, http_method, format, api_method_name, api_method_params, secure)
          end
        else
          old_method_missing(name, *args, &blk)
        end
      end
    end

    pb_read               :bundle,          'GetBundle'

    pb_read               :changes,         'GetChanges'

    pb_https_post_admin   :delete_file,     'DeleteFile',           :file            # **
    pb_plain_admin        :file,            'GetFile',              :filename
    pb_read               :file_revisions,  'GetFileRevisions'
    pb_admin              :files,           'GetFiles'
    pb_admin              :storage,         'GetStorageInfo'
    pb_https_post_admin   :put_file,        'PutFile',              :data            # **
    pb_https_post_admin   :rename_file,     'RenameFile',           :from, :to
    pb_https_post_admin   :revert_file,     'RevertFile',           :file, :revision
    
    pb_https_post_admin   :create_folder,   'CreateFolder',         :folder
    pb_https_post_admin   :delete_folder,   'DeleteFolder',         :folder
    pb_read               :file_folder,     'GetFileFolder',        :file
    pb_read               :folder_objects,  'GetFolderObjects',     :folder
    pb_read               :page_folder,     'GetPageFolder',        :page
    pb_admin              :folders,         'GetFolders'
    pb_admin              :file_folders,    'GetFileFolders'
    pb_https_post_admin   :rename_folder,   'RenameFolder',         :folder, :to      # **
    pb_https_post_admin   :set_file_folder, 'SetFileFolder',        :file
    pb_https_post_admin   :set_page_folder, 'SetPageFolder',        :page

    pb_admin              :create_user,     'CreateUser',           :user, :password
    pb_admin              :create_wiki,     'CreateWiki',           :tz, :wiki, :cat
    pb_admin              :index,           'Index'
    pb_admin              :multi,           'Multi',                :calls
    pb_read               :render,          'RenderContent',        :text

    pb_read               :templates,       'GetTemplates'
    pb_read               :times,           'GetTimes'

    pb_admin              :network_users,   'GetNewtorkUsers',      :anchor, :count, :filter, :offset, :sortby, :reverse, :verbose, :perm, :pending

    pb_admin              :objects,         'GetObjects',           :folder
    pb_admin              :ops,             'GetOps'
    pb_admin              :help,            'Help',                 :help
    pb_admin              :is_hiring,       'IsHiringEngineers'
    pb_read               :pagebase,        'PageBase'
    pb_admin              :ping,            'Ping'

    pb_https_post_write   :append_page,     'AppendPage',           :page, :html
    pb_https_post_write   :create_page,     'CreatePage',           :page
    pb_write              :delete_autosave, 'DeleteAutosave',       :page
    pb_https_post_admin   :delete_page,     'DeletePage',           :page
    
    pb_admin              :page,            'GetPage',              :page
    pb_admin              :page_lock,       'GetPageLock',          :page
    pb_admin              :page_security,   'GetPageSecurity',      :page
    pb_read               :pages,           'GetPages'
    pb_read               :search,          'Search',               :q

    pb_admin              :folder_security, 'GetFolderSecurity',    :folder

    pb_read               :page_tags,       'GetPageTags',          :page
    pb_read               :tag_pages,       'GetTagPages',          :tag
    pb_read               :tags,            'GetTags'

    pb_read               :milestone,       'GetMilestone',         :milestone_id
    pb_read               :milestones,      'GetMilestones'
    pb_read               :task,            'GetTask',              :task_id
    pb_read               :task_events,     'GetTaskEvents',        :task_id
    pb_read               :tasks,           'GetTasks'

    pb_read               :user,            'GetUserInfo'
    pb_read               :user_pref,       'GetUserPref',          :key
    pb_read               :user_prefs,      'GetUserPrefs',         :keys
    pb_admin              :users,           'GetUsersInfos'

    pb_admin              :upgrade_info,    'GetUpgradeInfo',       :wiki
    pb_admin              :leave,           'LeaveWorkspace',       :wiki

  end
end

