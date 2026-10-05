create table if not exists public.requests (
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(name) between 1 and 100),
  phone text not null check (char_length(phone) between 1 and 30),
  email text check (email is null or char_length(email) <= 120),
  service text not null check (char_length(service) between 1 and 100),
  status text not null default 'new' check (status in ('new', 'progress', 'done', 'cancelled')),
  request_date date not null default current_date,
  note text not null default '' check (char_length(note) <= 1000),
  created_at timestamptz not null default now()
);

alter table public.requests enable row level security;

grant usage on schema public to anon;
grant select, insert, update, delete on table public.requests to anon;

drop policy if exists "Anyone can manage requests" on public.requests;
create policy "Anyone can manage requests"
  on public.requests
  for all
  to anon
  using (true)
  with check (true);
