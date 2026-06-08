-- AI Blog Cloud 用 Supabase スキーマ
-- Supabase SQL Editor で実行してください。

create table if not exists public.ai_blog_entries (
  profile_id text not null,
  id text not null,
  title text not null default '',
  url text not null default '',
  domain text not null default '',
  tags jsonb not null default '[]'::jsonb,
  comment text not null default '',
  palette jsonb not null default '[]'::jsonb,
  pinned boolean not null default false,
  saved_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  primary key (profile_id, id)
);

create table if not exists public.ai_blog_settings (
  profile_id text not null primary key,
  blog_title text not null default 'My Blog*',
  theme text not null default 'light',
  view_mode text not null default 'list',
  palette_bg text not null default 'mid',
  updated_at timestamptz not null default now()
);

alter table public.ai_blog_entries enable row level security;
alter table public.ai_blog_settings enable row level security;

grant select, insert, update, delete on public.ai_blog_entries to anon;
grant select, insert, update, delete on public.ai_blog_settings to anon;

drop policy if exists "ai_blog_entries_anon_select" on public.ai_blog_entries;
drop policy if exists "ai_blog_entries_anon_insert" on public.ai_blog_entries;
drop policy if exists "ai_blog_entries_anon_update" on public.ai_blog_entries;
drop policy if exists "ai_blog_entries_anon_delete" on public.ai_blog_entries;
drop policy if exists "ai_blog_settings_anon_select" on public.ai_blog_settings;
drop policy if exists "ai_blog_settings_anon_insert" on public.ai_blog_settings;
drop policy if exists "ai_blog_settings_anon_update" on public.ai_blog_settings;
drop policy if exists "ai_blog_settings_anon_delete" on public.ai_blog_settings;

create policy "ai_blog_entries_anon_select" on public.ai_blog_entries for select to anon using (true);
create policy "ai_blog_entries_anon_insert" on public.ai_blog_entries for insert to anon with check (profile_id <> '');
create policy "ai_blog_entries_anon_update" on public.ai_blog_entries for update to anon using (profile_id <> '') with check (profile_id <> '');
create policy "ai_blog_entries_anon_delete" on public.ai_blog_entries for delete to anon using (profile_id <> '');

create policy "ai_blog_settings_anon_select" on public.ai_blog_settings for select to anon using (true);
create policy "ai_blog_settings_anon_insert" on public.ai_blog_settings for insert to anon with check (profile_id <> '');
create policy "ai_blog_settings_anon_update" on public.ai_blog_settings for update to anon using (profile_id <> '') with check (profile_id <> '');
create policy "ai_blog_settings_anon_delete" on public.ai_blog_settings for delete to anon using (profile_id <> '');

create index if not exists ai_blog_entries_profile_updated_idx on public.ai_blog_entries (profile_id, updated_at desc);
create index if not exists ai_blog_entries_profile_saved_idx on public.ai_blog_entries (profile_id, saved_at desc);
