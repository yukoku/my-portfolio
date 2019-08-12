desc "This task is called by the Heroku scheduler add-on"
task :purge_unattached_blobs => :environment do
  ActiveStorage::Blob.unattached.find_each(&:purge)
end