module HandoverHelper
  def create_or_update_handover_path(handover)
    return handover_path(uuid: handover.uuid) if handover.uuid.present?
    handovers_path
  end
end
