-- HashTag Network : table partagée de la partie Projet
-- À coller dans Supabase > SQL Editor, puis cliquer sur Run.

create table if not exists public.projet (
  id   text primary key,
  v    jsonb,
  by   text,
  at   bigint
);

alter table public.projet enable row level security;
grant select, insert, update, delete on public.projet to anon;

-- Tout le monde qui a le lien peut lire et modifier (pas de compte).
-- Ne partagez donc le lien du site qu'avec le groupe.
drop policy if exists "projet lecture" on public.projet;
drop policy if exists "projet ajout" on public.projet;
drop policy if exists "projet modification" on public.projet;
drop policy if exists "projet suppression" on public.projet;
create policy "projet lecture"      on public.projet for select to anon using (true);
create policy "projet ajout"        on public.projet for insert to anon with check (true);
create policy "projet modification" on public.projet for update to anon using (true) with check (true);
create policy "projet suppression"  on public.projet for delete to anon using (true);

-- Mises à jour en direct entre les membres
alter table public.projet replica identity full;
do $$ begin
  alter publication supabase_realtime add table public.projet;
exception when duplicate_object then null; end $$;
