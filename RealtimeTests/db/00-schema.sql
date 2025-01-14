﻿ALTER SYSTEM SET wal_level='logical';
ALTER SYSTEM SET max_wal_senders='10';
ALTER SYSTEM SET max_replication_slots='10';

-- Tables for testing

CREATE TYPE public.user_status AS ENUM ('ACTIVE', 'INACTIVE');
CREATE TABLE public.users (
  id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name text
);
INSERT INTO 
    public.users (name) 
VALUES 
    ('Joe Bloggs'),
    ('Jane Doe');

CREATE TABLE public.todos (
  id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  details text,
  numbers int[],
  user_id bigint REFERENCES users NOT NULL,
  inserted_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

INSERT INTO 
    public.todos (details, user_id)
VALUES 
    ('Star the repo', 1),
    ('Watch the releases', 2);

-- Create the Replication publication 
CREATE PUBLICATION supabase_realtime FOR ALL TABLES;