package funkin.backend.scripting.events;

import funkin.game.PlayState.PlayStateTransitionData;

final class RegisterSmoothEvent extends CancellableEvent {
  public var smoothTransition:PlayStateTransitionData;
}
