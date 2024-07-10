program sdl_musicsound;
uses SDL2, SDL2_mixer;

var
  sdlWindow: PSDL_Window;
  sdlRenderer: PSDL_Renderer;
  sdlSurface: PSDL_Surface;
  sdlTexture: PSDL_Texture;
  sdlKeyboardState: PUInt8;
  Music: PMix_Music;
  Sound: PMix_Chunk;
  Run: Boolean = True;

begin
  if SDL_Init(SDL_INIT_VIDEO or SDL_INIT_AUDIO) < 0 then Exit;

  // Get window and renderer
  if SDL_CreateWindowAndRenderer(
    640, 640, SDL_WINDOW_SHOWN, @sdlWindow,@sdlRenderer) <> 0 then Exit;

  // Create and render menu texture
  sdlSurface := SDL_LoadBMP('music-menu.bmp');
  if sdlSurface = nil then Exit;
  sdlTexture := SDL_CreateTextureFromSurface(sdlRenderer, sdlSurface);
  if sdlTexture = nil then Exit;
  if SDL_RenderCopy(sdlRenderer, sdlTexture, nil, nil) <> 0 then Exit;
  SDL_RenderPresent(sdlRenderer);

  // Prepare mixer
  if Mix_OpenAudio(MIX_DEFAULT_FREQUENCY, MIX_DEFAULT_FORMAT,
    MIX_DEFAULT_CHANNELS, 4096) < 0 then Exit;

  // Load music
  Music := Mix_LoadMUS('In-my-mind-1.ogg');
  if Music = nil then Exit;
  Mix_VolumeMusic(MIX_MAX_VOLUME);

  // Load sound
  Sound := Mix_LoadWAV('dial-1.wav');
  if Sound = nil then Exit;
  Mix_VolumeChunk(Sound, MIX_MAX_VOLUME);

  while Run = True do
  begin

    SDL_PumpEvents;
    sdlKeyboardState := SDL_GetKeyboardState(nil);

    // ESC pressed
    if sdlKeyboardState[SDL_SCANCODE_ESCAPE] = 1 then
      Run := False;

    // Music effect keys
    if sdlKeyboardState[SDL_SCANCODE_1] = 1 then
      if Mix_PlayMusic(Music, 0) < 0 then Writeln(SDL_GetError);
    if sdlKeyboardState[SDL_SCANCODE_2] = 1 then Mix_PauseMusic;
    if sdlKeyboardState[SDL_SCANCODE_3] = 1 then Mix_ResumeMusic;
    if sdlKeyboardState[SDL_SCANCODE_4] = 1 then Mix_RewindMusic;
    if sdlKeyboardState[SDL_SCANCODE_5] = 1 then
      if Mix_FadeInMusic(Music, 10, 3000) = 0 then Writeln(SDL_GetError);
    if sdlKeyboardState[SDL_SCANCODE_6] = 1 then
      if Mix_FadeOutMusic(3000) = 0 then Writeln(SDL_GetError);

    // Sound effect keys
    if sdlKeyboardState[SDL_SCANCODE_7] = 1 then
      if Mix_PlayChannel(1, Sound, 0) < 0 then Writeln(SDL_GetError);
    if sdlKeyboardState[SDL_SCANCODE_8] = 1 then
      if Mix_PlayChannel(-1, Sound, 0) < 0 then Writeln(SDL_GetError);
    if sdlKeyboardState[SDL_SCANCODE_9] = 1 then Mix_Pause(-1);
    if sdlKeyboardState[SDL_SCANCODE_0] = 1 then Mix_Resume(-1);
    if sdlKeyboardState[SDL_SCANCODE_A] = 1 then
      if Mix_FadeInChannel(1, sound, 0, 2000) < 0 then Writeln(SDL_GetError);
    if sdlKeyboardState[SDL_SCANCODE_S] = 1 then
      if Mix_FadeOutChannel(1, 1000) < 0 then Writeln(SDL_GetError);

    // Channel effect keys
     if sdlKeyboardState[SDL_SCANCODE_G] = 1 then
       if Mix_SetPanning( 1, 255, 32 ) = 0 then Writeln(SDL_GetError);
     if sdlKeyboardState[SDL_SCANCODE_H] = 1 then
       if Mix_SetPanning( 1, 255, 255 ) = 0 then Writeln(SDL_GetError);
     if sdlKeyboardState[SDL_SCANCODE_J] = 1 then
       if Mix_SetDistance( 1, 223 ) = 0 then Writeln(SDL_GetError);
     if sdlKeyboardState[SDL_SCANCODE_K] = 1 then
       if Mix_SetDistance( 1, 0 ) = 0 then Writeln(SDL_GetError);
     if sdlKeyboardState[SDL_SCANCODE_L] = 1 then
       if Mix_SetPosition( 1, 45, 127 ) = 0 then Writeln(SDL_GetError);
     if sdlKeyboardState[SDL_SCANCODE_M] = 1 then
       if Mix_SetPosition( 1, 0, 0 ) = 0 then Writeln(SDL_GetError);

  end;

  // Clean up
  if Assigned(sdlSurface) then SDL_FreeSurface(sdlSurface);
  if Assigned(sdlTexture) then SDL_DestroyTexture(sdlTexture);
  if Assigned(sdlRenderer) then SDL_DestroyRenderer(sdlRenderer);
  if Assigned(sdlWindow) then SDL_DestroyWindow(sdlWindow);
  if Assigned(Music) then Mix_FreeMusic(Music);
  if Assigned(Sound) then Mix_FreeChunk(Sound);

  Mix_CloseAudio;
  SDL_Quit;
end.
