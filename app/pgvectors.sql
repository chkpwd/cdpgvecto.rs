ALTER SYSTEM SET shared_preload_libraries = "vectors.so"
ALTER SYSTEM SET search_path TO "$user", public, vectors
GRANT SELECT ON TABLE pg_vector_index_stat to PUBLIC
