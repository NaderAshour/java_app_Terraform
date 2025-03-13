

output "rds_endpoint" {
     value = aws_db_instance.db01.address 
     }

output "memcached_endpoint" {
     value = aws_elasticache_cluster.mc01.cache_nodes[0].address
      }